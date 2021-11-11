const std = @import("std");

const sdl = @import("sdl2");
const spu = @import("spu-mk2");
const args = @import("args");

const CliArgs = struct {
    const SerialPort = enum {
        none,
        stdio,
    };

    help: bool = false,
    serial1: SerialPort = .none,
    serial2: SerialPort = .none,
};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const global_allocator = &gpa.allocator;

pub fn main() !u8 {
    defer _ = gpa.deinit();

    const stderr = std.io.getStdErr().writer();
    // const stdout = std.io.getStdOut().writer();

    const cli = args.parseForCurrentProcess(CliArgs, global_allocator, .print) catch return 1;
    defer cli.deinit();

    if (cli.options.help) {
        try usage(stderr);
        return 0;
    }

    if (cli.positionals.len == 0) {
        try usage(stderr);
        return 1;
    }

    try sdl.init(.{
        .video = true,
        .events = true,
    });
    defer sdl.quit();

    var window = try sdl.createWindow(
        "Ashet Home Computer",
        .centered,
        .centered,
        640,
        480,
        .{},
    );
    defer window.destroy();

    var renderer = try sdl.createRenderer(window, null, .{
        .accelerated = true,
        .present_vsync = true,
    });
    defer renderer.destroy();

    var render_target = try sdl.createTexture(
        renderer,
        .bgr565,
        .streaming,
        640,
        480,
    );

    const ashet: *Ashet = try global_allocator.create(Ashet);
    defer global_allocator.destroy(ashet);

    Ashet.init(ashet);
    defer ashet.deinit();

    var dbg = DebugInterface.init(global_allocator);
    defer dbg.deinit();
    ashet.cpu.debug_interface = &dbg.interface;

    var success = true; //  we require at least one boot image file

    for (cli.positionals) |file| {
        const ext = fileExtension(file) orelse {
            try stderr.print("{s} is missing a file extension, cannot autodetect the file type!\n", .{file});
            success = false;
            continue;
        };

        if (std.mem.eql(u8, ext, "bin")) {
            _ = try std.fs.cwd().readFile(file, &ashet.bus.memory);
        } else if (std.mem.eql(u8, ext, "hex")) {
            try stderr.writeAll("ihex loading is not implemented yet!\n");
            success = false;
        } else {
            try stderr.print("{s} is not a supported BIOS format!\n", .{ext});
            success = false;
        }
    }

    if (!success) {
        return 1;
    }

    if (std.builtin.mode == .Debug) {
        ashet.vga.debug_view_active = true;
    }

    main_loop: while (true) {
        while (sdl.pollEvent()) |event| {
            switch (event) {
                .quit => break :main_loop,
                .key_down => |kd| {
                    const has_shift = (kd.keysym.mod & (sdl.c.KMOD_LSHIFT | sdl.c.KMOD_RSHIFT)) != 0;
                    switch (kd.keysym.sym) {
                        sdl.c.SDLK_F1 => if (has_shift) {
                            ashet.cpu.triggerInterrupt(.reset);
                        } else {
                            ashet.cpu.triggerInterrupt(.arith);
                        },
                        sdl.c.SDLK_F2 => if (has_shift) {
                            ashet.cpu.triggerInterrupt(.nmi);
                        } else {
                            ashet.cpu.triggerInterrupt(.software);
                        },
                        sdl.c.SDLK_F3 => if (has_shift) {
                            ashet.cpu.triggerInterrupt(.bus);
                        } else {
                            ashet.cpu.triggerInterrupt(.reserved);
                        },
                        sdl.c.SDLK_F4 => if (has_shift) {} else {
                            ashet.cpu.triggerInterrupt(.irq);
                        },

                        sdl.c.SDLK_F5 => {
                            if (dbg.is_paused) {
                                dbg.@"continue"();
                            } else {
                                dbg.@"break"();
                            }
                        },

                        sdl.c.SDLK_F10 => {
                            if (dbg.is_paused) {
                                dbg.executeSingleStep();
                            }
                        },

                        // This is a (physical) HW switch
                        sdl.c.SDLK_F12 => ashet.vga.debug_view_active = !ashet.vga.debug_view_active,
                        else => {},
                    }
                },
                else => {},
            }
        }

        // Step the emulation

        // const timer = try std.time.Timer.start();

        if (!dbg.is_paused) {
            ashet.runFor(16 * std.time.ns_per_ms) catch |err| switch (err) {
                error.DebugBreak => std.log.info("debug break at 0x{X:0>4}", .{ashet.cpu.ip}), // we will handle this properly by ignoring it
                else => |e| return e,
            };
        }

        // const time = @intToFloat(f64, timer.read()) / std.time.ns_per_ms;

        // std.debug.warn("emulation time: {d}ms\n", .{time});

        // Fetch the VGA screen output
        var fb: [480][640]VGA.RGB = undefined;
        try ashet.vga.render(&fb);

        try render_target.update(std.mem.sliceAsBytes(&fb), 640 * @sizeOf(VGA.RGB), null);

        try renderer.copy(render_target, null, null);

        renderer.present();
    }

    return 0;
}

const DebugInterface = struct {
    const Self = @This();

    interface: spu.DebugInterface = .{
        .traceInstructionFn = traceInstruction,
        .traceAddressFn = traceAddress,
    },

    breakpoints: std.ArrayList(u16),

    is_paused: bool,
    auto_break: bool,

    pub fn init(allocator: *std.mem.Allocator) Self {
        return Self{
            .breakpoints = std.ArrayList(u16).init(allocator),
            .is_paused = false,
            .auto_break = false,
        };
    }

    pub fn deinit(self: *Self) void {
        self.breakpoints.deinit();
        self.* = undefined;
    }

    pub fn enableBreakpoint(self: *Self, address: u16) !void {
        std.debug.assert((address & 1) == 0);

        if (std.mem.indexOfScalar(u16, self.breakpoints.items, address) == null) {
            try self.breakpoints.append(address);
        }
    }

    pub fn disableBreakpoint(self: *Self, address: u16) void {
        std.debug.assert((address & 1) == 0);

        if (std.mem.indexOfScalar(u16, self.breakpoints.items, address)) |index| {
            self.breakpoints.swapRemove(index);
        }
    }

    pub fn @"break"(self: *Self) void {
        self.is_paused = true;
    }

    pub fn @"continue"(self: *Self) void {
        self.is_paused = false;
        self.auto_break = false;
    }

    pub fn executeSingleStep(self: *Self) void {
        self.is_paused = false;
        self.auto_break = true;
    }

    fn fmtInstruction(buf: []u8, instruction: spu.Instruction, input0: u16, input1: u16, output: u16) !void {
        var stream = std.io.fixedBufferStream(buf);
        const writer = stream.writer();

        try writer.writeAll(@tagName(instruction.command));
        try writer.print("(0x{X:0>4}, 0x{X:0>4})", .{ input0, input1 });
        if (instruction.output != .discard) {
            try writer.print(" => 0x{X:0>4}", .{output});
        }
    }

    fn traceInstruction(interface: *spu.DebugInterface, ip: u16, instruction: spu.Instruction, input0: u16, input1: u16, output: u16) void {
        const self = @fieldParentPtr(Self, "interface", interface);
        if (self.is_paused or self.auto_break) {
            var buf = std.mem.zeroes([64]u8);

            fmtInstruction(&buf, instruction, input0, input1, output) catch {};

            std.log.info("trace: 0x{X:0>4}: {s}", .{ ip, &buf });
        }
    }

    fn traceAddress(interface: *spu.DebugInterface, virt: u16) spu.DebugInterface.TraceError!void {
        const self = @fieldParentPtr(Self, "interface", interface);
        //
        _ = self;
        _ = virt;

        if (self.is_paused)
            return error.DebugBreak;

        if (self.auto_break)
            self.is_paused = true;

        if (std.mem.indexOfScalar(u16, self.breakpoints.items, virt) != null) {
            self.is_paused = true;
            return error.DebugBreak;
        }
    }
};

fn usage(out: anytype) !void {
    try out.writeAll(
        \\ashet [BIOS.bin]
        \\--help                             Displays this help message
        \\--serial1, --serial2 [none|stdio]  Configures the serial port 1 or 2.
        \\                                   none:  The serial port has no I/O capabilities.
        \\                                   stdio: The serial port is emulated via stdin and stdout.
        \\
    );
}

const BusDevice = struct {
    const Self = @This();

    const UnmappedImpl = struct {
        fn read8(p: *Self, address: u24) !u8 {
            _ = p;
            _ = address;
            return error.BusError;
        }
        fn read16(p: *Self, address: u24) !u16 {
            _ = p;
            _ = address;
            return error.BusError;
        }

        fn write8(p: *Self, address: u24, value: u8) !void {
            _ = p;
            _ = address;
            _ = value;
        }
        fn write16(p: *Self, address: u24, value: u16) !void {
            _ = p;
            _ = address;
            _ = value;
        }
    };

    var unmapped_stor = Self{
        .read8Fn = UnmappedImpl.read8,
        .read16Fn = UnmappedImpl.read16,
        .write8Fn = UnmappedImpl.write8,
        .write16Fn = UnmappedImpl.write16,
        .offset = 0,
        .register_bank_size = 0,
    };
    pub const unmapped: *Self = &unmapped_stor;

    pub const Error = error{
        BusError,
        UnalignedAccess,
    };

    read8Fn: fn (*Self, u24) Error!u8,
    read16Fn: fn (*Self, u24) Error!u16,

    write8Fn: fn (*Self, u24, u8) Error!void,
    write16Fn: fn (*Self, u24, u16) Error!void,

    offset: u12,
    register_bank_size: u12,

    pub fn read8(self: *Self, address: u24) !u8 {
        return self.read8Fn(self, address);
    }

    pub fn write8(self: *Self, address: u24, value: u8) !void {
        return self.write8Fn(self, address, value);
    }

    pub fn read16(self: *Self, address: u24) !u16 {
        if (!isWordAlignedAddress(address))
            return error.UnalignedAccess;
        return self.read16Fn(self, address);
    }

    pub fn write16(self: *Self, address: u24, value: u16) !void {
        if (!isWordAlignedAddress(address))
            return error.UnalignedAccess;
        return self.write16Fn(self, address, value);
    }

    fn read16With8(self: *Self, address: u24) !u16 {
        return (@as(u16, try self.read8(address + 0)) << 0) |
            (@as(u16, try self.read8(address + 1)) << 8);
    }

    fn write16With8(self: *Self, address: u24, value: u16) !void {
        try self.write8(address + 0, @truncate(u8, value >> 0));
        try self.write8(address + 1, @truncate(u8, value >> 8));
    }

    fn read8With16(self: *Self, address: u24) !u8 {
        const val = try self.read16(address & 0xFFFE);
        return if ((address & 1) == 1)
            @truncate(u8, val >> 8)
        else
            @truncate(u8, val >> 0);
    }

    fn write8With16(self: *Self, address: u24, value: u8) !void {
        const aligned_address = address & 0xFFFE;
        const current_val = try self.read16(aligned_address);
        try self.write16(aligned_address, if ((address & 1) == 1)
            (@as(u16, value) << 8) & (current_val & 0x00FF)
        else
            (@as(u16, value) << 0) & (current_val & 0xFF00));
    }
};

const Ashet = struct {
    const Self = @This();

    // System configuration
    cpu_clock: u64 = 10_000_000, // instructions per second

    // Memory interface
    bus: Bus,

    devices: [20]*BusDevice,

    mmu: MMU,
    cpu: spu.SpuMk2(*MMU),

    // Memory mapped parts
    vga: VGA,
    uarts: [4]UART,

    // Emulation state

    /// emulation time in nanoseconds
    emulation_time: u64 = 0,
    real_time: u64 = 0,

    // After a call to init, `self` must not be moved anymore!
    pub fn init(self: *Self) void {
        self.* = Self{
            .cpu = spu.SpuMk2(*MMU).init(&self.mmu),

            .bus = Bus{
                .devices = &self.devices,
            },

            .devices = [_]*BusDevice{
                &self.mmu.bus_device, //      0x7FE000  MMU
                BusDevice.unmapped, //        0x7FE030  IRQ
                &self.uarts[0].bus_device, // 0x7FE040  UART 16C550-Style (1)
                &self.uarts[1].bus_device, // 0x7FE050  UART 16C550-Style (2)
                &self.uarts[2].bus_device, // 0x7FE060  UART 16C550-Style (3)
                &self.uarts[3].bus_device, // 0x7FE070  UART 16C550-Style (4)
                BusDevice.unmapped, //        0x7FE080  PS/2 (1)
                BusDevice.unmapped, //        0x7FE090  PS/2 (2)
                BusDevice.unmapped, //        0x7FE0A0  IDE / PATA
                BusDevice.unmapped, //        0x7FE0B0  Timer (1)
                BusDevice.unmapped, //        0x7FE0C0  Timer (2)
                BusDevice.unmapped, //        0x7FE0D0  RTC
                BusDevice.unmapped, //        0x7FE0E0  Joystick (1)
                BusDevice.unmapped, //        0x7FE0F0  Joystick (2)
                BusDevice.unmapped, //        0x7FE100  Parallel Port
                BusDevice.unmapped, //        0x7FE110  PCM Audio Control/Status
                BusDevice.unmapped, //        0x7FE110  DMA Control/Status
                &self.vga.bus_device_control, // 0x7FE110 272 8	VGA Card
                BusDevice.unmapped, // 0x7FE120 288 13	Ethernet
                &self.vga.bus_device_palette, // 0x7FE200 512 512	VGA Palette Memory
            },

            .mmu = MMU{
                .bus = &self.bus,
            },

            .vga = VGA{
                .bus = &self.bus,
                .framebuffer_address = 0x000000,
            },
            .uarts = [4]UART{
                UART.init(0),
                UART.init(1),
                UART.init(2),
                UART.init(3),
            },
        };

        // MMU is by-default in an identity mapping, so we need to map the I/O page into the visible range.
        // In this case, we map it into the last page of memory space
        self.mmu.page_config[0xF].physical_address = 0x7FE;
    }

    pub fn deinit(self: *Self) void {
        self.* = undefined;
    }

    /// Runs the emulation for the given amount of nanoseconds
    pub fn runFor(self: *Self, ns: u64) !void {
        const granularity = 1 * std.time.ns_per_us; // Run with 1µs steps

        self.real_time += ns;

        // this has a minimal error per clock, but we accept this
        const ns_per_cycle = std.time.ns_per_s / self.cpu_clock;
        const cycles_per_step = granularity / ns_per_cycle;

        while (self.emulation_time < self.real_time) : (self.emulation_time += granularity) {

            // TODO: Process inputs from UART1, PS/2, IrDA

            // Now, run the CPU
            self.cpu.runBatch(cycles_per_step) catch |err| {
                if (err == error.DebugBreak)
                    return error.DebugBreak;

                self.bus.enable_debug_msg = false;
                defer self.bus.enable_debug_msg = true;

                std.debug.print("CPU crashed at {X:0>4}:\n", .{
                    self.cpu.ip,
                });

                std.debug.print("   IP={X:0>4} SP={X:0>4} BP={X:0>4} FR={X:0>4}\n", .{
                    self.cpu.ip,
                    self.cpu.sp,
                    self.cpu.bp,
                    @bitCast(u16, self.cpu.fr),
                });

                var stack_ptr: u16 = self.cpu.sp -% 8;
                while (stack_ptr != self.cpu.sp +% 10) : (stack_ptr +%= 2) {
                    const value = self.mmu.memReadWord(stack_ptr) catch null;
                    const indicator = if (stack_ptr == self.cpu.sp)
                        "-->"
                    else
                        "   ";
                    if (value) |val| {
                        std.debug.print("{s}{X:0>4}: {X:0>4}\n", .{
                            indicator,
                            stack_ptr,
                            val,
                        });
                    } else {
                        std.debug.print("{s}{X:0>4}: ????\n", .{
                            indicator,
                            stack_ptr,
                        });
                    }
                }

                return err;
            };

            // TODO: Process outputs from UART1, PS/2, IrDA

            for (self.uarts) |*uart, i| {
                while (uart.output.readItem()) |item| {
                    std.debug.print("UART{d}: {X:0>2} {c}\n", .{ i, item, item });
                }
            }
        }
    }
};

const Bus = struct {
    const Self = @This();

    const io_base = 0x7FE000;

    memory: [1 << 24]u8 align(2) = undefined,
    devices: []*BusDevice,
    enable_debug_msg: bool = true,

    fn deviceAt(self: *Self, offset: u12) !*BusDevice {
        for (self.devices) |dev| {
            if (offset >= dev.offset and offset < dev.offset + dev.register_bank_size)
                return dev;
        }
        return error.BusError;
    }

    const BusAccess = enum { read, write };
    const AccessSize = enum { word, byte };
    fn logError(self: Self, err: BusDevice.Error, address: u24, access: BusAccess, size: AccessSize) BusDevice.Error {
        if (!self.enable_debug_msg)
            return err;
        // workaround for https://github.com/ziglang/zig/issues/7097
        const access_msg: []const u8 = switch (access) {
            .read => switch (size) {
                .byte => "reading byte from",
                .word => "reading word from",
            },
            .write => switch (size) {
                .byte => "writing byte to",
                .word => "writing word to",
            },
        };
        std.debug.print("{s} when {s} {X:0>6}\n", .{
            @errorName(err),
            access_msg,
            address,
        });
        return err;
    }

    pub fn read8(self: *Self, address: u24) !u8 {
        return switch (address) {
            io_base...io_base + 0xFFF => try (try self.deviceAt(@truncate(u12, address - io_base))).read8(address) catch |err| self.logError(err, address, .read, .byte),
            else => self.memory[address],
        };
    }

    pub fn write8(self: *Self, address: u24, value: u8) !void {
        switch (address) {
            io_base...io_base + 0xFFF => try (try self.deviceAt(@truncate(u12, address - io_base))).write8(address, value) catch |err| self.logError(err, address, .read, .byte),
            else => self.memory[address] = value,
        }
    }

    pub fn read16(self: *Self, address: u24) !u16 {
        std.debug.assert((address & 0x01) == 0);
        return switch (address) {
            io_base...io_base + 0xFFF => try (try self.deviceAt(@truncate(u12, address - io_base))).read16(address) catch |err| self.logError(err, address, .read, .byte),
            else => std.mem.readIntLittle(u16, self.memory[address..][0..2]),
        };
    }

    pub fn write16(self: *Self, address: u24, value: u16) !void {
        std.debug.assert((address & 0x01) == 0);
        switch (address) {
            io_base...io_base + 0xFFF => try (try self.deviceAt(@truncate(u12, address - io_base))).write16(address, value) catch |err| self.logError(err, address, .read, .byte),
            else => std.mem.writeIntLittle(u16, self.memory[address..][0..2], value),
        }
    }
};

const Memory = struct {
    const Self = @This();

    data: []u8,
    read_only: bool,
    addr_mask: usize,

    bus_device: BusDevice = BusDevice{
        .read16Fn = read16,
        .write16Fn = write16,

        .read8Fn = read8,
        .write8Fn = write8,
    },

    pub fn init(data: []u8, read_only: bool) Self {
        return Self{
            .data = data,
            .read_only = read_only,
            .addr_mask = (std.math.ceilPowerOfTwo(usize, data.len) catch unreachable) - 1,
        };
    }

    fn read8(busdev: *BusDevice, address: u24) !u8 {
        const mem = @fieldParentPtr(Self, "bus_device", busdev);
        const offset = address & mem.addr_mask;

        return if (offset < mem.data.len)
            mem.data[offset]
        else
            return error.BusError;
    }

    fn write8(busdev: *BusDevice, address: u24, value: u8) !void {
        const mem = @fieldParentPtr(Self, "bus_device", busdev);
        if (mem.read_only)
            return error.BusError;

        const offset = address & mem.addr_mask;

        if (offset < mem.data.len) {
            mem.data[offset] = value;
        } else {
            return error.BusError;
        }
    }

    fn read16(busdev: *BusDevice, address: u24) !u16 {
        const mem = @fieldParentPtr(Self, "bus_device", busdev);
        const offset = address & mem.addr_mask;
        return if (offset < mem.data.len - 1)
            std.mem.readIntLittle(u16, mem.data[offset..][0..2])
        else
            return error.BusError;
    }

    fn write16(busdev: *BusDevice, address: u24, value: u16) !void {
        const mem = @fieldParentPtr(Self, "bus_device", busdev);
        if (mem.read_only)
            return error.BusError;

        const offset = address & mem.addr_mask;

        if (offset < mem.data.len - 1) {
            std.mem.writeIntLittle(u16, mem.data[offset..][0..2], value);
        } else {
            return error.BusError;
        }
    }
};

const VGA = struct {
    const Self = @This();
    const RGB = packed struct {
        r: u5,
        g: u6,
        b: u5,

        fn init(r: u8, g: u8, b: u8) RGB {
            return RGB{
                .r = @truncate(u5, r >> 3),
                .g = @truncate(u6, g >> 2),
                .b = @truncate(u5, b >> 3),
            };
        }
    };

    bus_device_palette: BusDevice = BusDevice{
        .read8Fn = BusDevice.read8With16,
        .write8Fn = BusDevice.write8With16,

        .read16Fn = paletteRead16,
        .write16Fn = paletteWrite16,

        .offset = 0x110,
        .register_bank_size = 8,
    },
    bus_device_control: BusDevice = BusDevice{
        .read8Fn = BusDevice.read8With16,
        .write8Fn = BusDevice.write8With16,

        .read16Fn = registerRead16,
        .write16Fn = registerWrite16,

        .offset = 0x200,
        .register_bank_size = 512,
    },

    palette: [256]RGB = init: {
        var pal: [256]RGB = undefined;
        var i: usize = 0;
        while (i < 256) : (i += 1) {
            pal[i] = RGB.init(
                @truncate(u8, i),
                @truncate(u8, i),
                @truncate(u8, i),
            );
        }
        break :init pal;
    },

    bus: *Bus,

    border_color: VGA.RGB = VGA.RGB.init(0x30, 0x34, 0x6d),
    framebuffer_address: u32 = 0x000000,
    framebuffer_stride: u32 = 0x000100, // default stride is a fully linear framebuffer

    debug_view_active: bool = false,

    /// Writes out the VGA image to a framebuffer
    pub fn render(self: *Self, frame_buffer: *[480][640]VGA.RGB) !void {
        for (frame_buffer) |*row| {
            for (row) |*pix| {
                pix.* = self.border_color;
            }
        }

        {
            var row_offset = @truncate(u24, self.framebuffer_address);

            const dx = (640 - 256 * 2) / 2;
            const dy = (480 - 128 * 2) / 2;

            var y: usize = 0;
            while (y < 128) : (y += 1) {
                var offset = row_offset;
                var x: usize = 0;
                while (x < 256) : (x += 1) {
                    const pixel_index = try self.bus.read8(offset);
                    const low = self.palette[pixel_index];

                    frame_buffer[dy + 2 * y + 0][dx + 2 * x + 0] = low;
                    frame_buffer[dy + 2 * y + 1][dx + 2 * x + 0] = low;
                    frame_buffer[dy + 2 * y + 0][dx + 2 * x + 1] = low;
                    frame_buffer[dy + 2 * y + 1][dx + 2 * x + 1] = low;

                    offset +%= 1; // might overflow
                }
                row_offset +%= @truncate(u24, self.framebuffer_stride); // might overflow
            }
        }

        const H = struct {
            fn printHexDigit(fb: *[480][640]VGA.RGB, x: usize, y: usize, comptime T: type, number: T, color: RGB) void {
                const digits = (@bitSizeOf(T) + 3) / 4;

                var left: usize = 0;

                var digit: usize = digits;
                while (digit > 0) {
                    digit -= 1;

                    const glyph = hexfont_8x8[(number >> @intCast(u4, 4 * digit)) & 0xF];

                    var dy: usize = 0;
                    while (dy < 7) : (dy += 1) {
                        comptime var dx = 0;
                        inline while (dx < 5) : (dx += 1) {
                            if ((glyph[dy] & (0x10 >> dx)) != 0) {
                                fb[y + 2 * dy + 0][left + x + 2 * dx + 0] = color;
                                fb[y + 2 * dy + 1][left + x + 2 * dx + 0] = color;
                                fb[y + 2 * dy + 0][left + x + 2 * dx + 1] = color;
                                fb[y + 2 * dy + 1][left + x + 2 * dx + 1] = color;
                            }
                        }
                    }

                    left += 12;
                }
            }
        };

        if (self.debug_view_active) {
            const ashet = @fieldParentPtr(Ashet, "vga", self);

            const color = RGB.init(0xFF, 0x00, 0x00);
            const color_hl = RGB.init(0xFF, 0xFF, 0xFF);

            H.printHexDigit(frame_buffer, 8, 8, u16, ashet.cpu.ip, color);
            H.printHexDigit(frame_buffer, 8, 24, u16, ashet.cpu.sp, color);
            H.printHexDigit(frame_buffer, 8, 40, u16, ashet.cpu.bp, color);
            H.printHexDigit(frame_buffer, 8, 56, u16, @bitCast(u16, ashet.cpu.fr), color);

            for (ashet.mmu.page_config) |cfg, i| {
                H.printHexDigit(frame_buffer, 8, 112 + 16 * i, u16, @bitCast(u16, cfg), color);
            }

            {
                var offset: u16 = ashet.cpu.sp;
                var i: u16 = 0;
                while (i < 16) : (i += 1) {
                    const value = ashet.cpu.readWord(offset) catch 0xFFFF;
                    offset +%= 2;

                    H.printHexDigit(
                        frame_buffer,
                        584,
                        112 + 16 * i,
                        u16,
                        value,
                        if (ashet.cpu.bp == offset)
                            color_hl
                        else
                            color,
                    );
                }
            }
        }
    }

    fn registerRead16(busdev: *BusDevice, address: u24) !u16 {
        const vga = @fieldParentPtr(Self, "bus_device_control", busdev);
        return switch ((address & 0x7FF) >> 1) {
            0 => @truncate(u16, vga.framebuffer_address),
            1 => @truncate(u16, vga.framebuffer_address >> 16),
            2 => @truncate(u16, vga.framebuffer_stride),
            3 => @truncate(u16, vga.framebuffer_stride >> 16),
            4 => @bitCast(u16, vga.border_color),
            else => return error.BusError,
        };
    }

    fn registerWrite16(busdev: *BusDevice, address: u24, value: u16) !void {
        const vga = @fieldParentPtr(Self, "bus_device_control", busdev);
        switch ((address & 0x7FF) >> 1) {
            0 => vga.framebuffer_address = (vga.framebuffer_address & 0xFFFF0000) | value,
            1 => vga.framebuffer_address = (vga.framebuffer_address & 0x0000FFFF) | (@as(u32, value) << 16),
            2 => vga.framebuffer_stride = (vga.framebuffer_stride & 0xFFFF0000) | value,
            3 => vga.framebuffer_stride = (vga.framebuffer_stride & 0x0000FFFF) | (@as(u32, value) << 16),
            4 => vga.border_color = @bitCast(VGA.RGB, value),
            else => return error.BusError,
        }
    }

    fn paletteRead16(busdev: *BusDevice, address: u24) !u16 {
        const vga = @fieldParentPtr(Self, "bus_device_palette", busdev);
        return @bitCast(u16, vga.palette[(address >> 1) & 0xFF]);
    }

    fn paletteWrite16(busdev: *BusDevice, address: u24, value: u16) !void {
        const vga = @fieldParentPtr(Self, "bus_device_palette", busdev);
        vga.palette[(address >> 1) & 0xFF] = @bitCast(RGB, value);
    }
};

const MMU = struct {
    const Self = @This();

    const Register = packed struct {
        enabled: bool = true,
        write_protected: bool = false,
        caching_enabled: bool = false,
        reserved: u1 = 0,
        physical_address: u12,
    };

    page_config: [16]Register = [16]Register{
        Register{ .physical_address = 0x000 },
        Register{ .physical_address = 0x001 },
        Register{ .physical_address = 0x002 },
        Register{ .physical_address = 0x003 },
        Register{ .physical_address = 0x004 },
        Register{ .physical_address = 0x005 },
        Register{ .physical_address = 0x006 },
        Register{ .physical_address = 0x007 },
        Register{ .physical_address = 0x008 },
        Register{ .physical_address = 0x009 },
        Register{ .physical_address = 0x00A },
        Register{ .physical_address = 0x00B },
        Register{ .physical_address = 0x00C },
        Register{ .physical_address = 0x00D },
        Register{ .physical_address = 0x00E },
        Register{ .physical_address = 0x00F },
    },

    page_fault_register: u16 = 0,
    write_fault_register: u16 = 0,

    /// The bus device that allows configuring the MMU
    bus_device: BusDevice = BusDevice{
        .read8Fn = BusDevice.read8With16,
        .write8Fn = BusDevice.write8With16,

        .read16Fn = registerRead16,
        .write16Fn = registerWrite16,

        .offset = 0x000,
        .register_bank_size = 48,
    },

    /// The bus that is managed by the MMU
    bus: *Bus,

    const TranslateResult = struct {
        address: u24,
        config: Register,
    };
    fn translateAddress(self: Self, virtual_address: u16) TranslateResult {
        const page = virtual_address >> 12;
        const mapping = self.page_config[page];

        return TranslateResult{
            .address = (@as(u24, mapping.physical_address) << 12) | @as(u24, virtual_address & 0x0FFF),
            .config = mapping,
        };
    }

    const Access = enum { read, write };
    fn accessAddress(self: Self, virtual_address: u16, access: Access) !u24 {
        const physical_address = self.translateAddress(virtual_address);
        if (!physical_address.config.enabled)
            return error.BusError;
        if (physical_address.config.write_protected and access != .read)
            return error.BusError;
        return physical_address.address;
    }

    pub const read8 = memReadByte;
    pub const write8 = memWriteByte;
    pub const read16 = memReadWord;
    pub const write16 = memWriteWord;

    fn memReadByte(self: *Self, address: u16) !u8 {
        return self.bus.read8(
            try self.accessAddress(address, .read),
        );
    }

    fn memWriteByte(self: *Self, address: u16, value: u8) !void {
        return self.bus.write8(
            try self.accessAddress(address, .write),
            value,
        );
    }

    fn memReadWord(self: *Self, address: u16) !u16 {
        return self.bus.read16(
            try self.accessAddress(address, .read),
        );
    }

    fn memWriteWord(self: *Self, address: u16, value: u16) !void {
        return self.bus.write16(
            try self.accessAddress(address, .write),
            value,
        );
    }

    fn registerRead16(busdev: *BusDevice, address: u24) !u16 {
        const mmu = @fieldParentPtr(Self, "bus_device", busdev);
        const register = (address & 0x7FF) >> 1;
        return switch (register) {
            0x000...0x00F => @bitCast(u16, mmu.page_config[register]),
            0x010 => mmu.page_fault_register,
            0x011 => mmu.write_fault_register,
            else => return error.BusError,
        };
    }

    fn registerWrite16(busdev: *BusDevice, address: u24, value: u16) !void {
        const mmu = @fieldParentPtr(Self, "bus_device", busdev);
        const register = (address & 0x7FF) >> 1;
        switch (register) {
            0x000...0x00F => mmu.page_config[register] = @bitCast(Register, value),
            0x010 => mmu.page_fault_register = value,
            0x011 => mmu.write_fault_register = value,
            else => return error.BusError,
        }
    }
};

const UART = struct {
    const Self = @This();
    const Fifo = std.fifo.LinearFifo(u8, .{ .Static = 16 });

    bus_device: BusDevice = BusDevice{
        .read8Fn = BusDevice.read8With16,
        .write8Fn = BusDevice.write8With16,

        .read16Fn = read16,
        .write16Fn = write16,

        .offset = undefined,
        .register_bank_size = 8,
    },

    input: Fifo = Fifo.init(),
    output: Fifo = Fifo.init(),

    pub fn init(index: u8) UART {
        var uart = UART{};
        uart.bus_device.offset = 0x030 + 32 * index;
        return uart;
    }

    fn read16(busdev: *BusDevice, address: u24) BusDevice.Error!u16 {
        const uart = @fieldParentPtr(Self, "bus_device", busdev);
        return switch ((address & 0x7FF) >> 1) {
            0 => if (uart.input.readItem()) |byte|
                @as(u16, byte)
            else
                0xFFFF,
            1 => blk: {
                var status: u16 = 0;

                if (uart.input.readableLength() == 0)
                    status |= (1 << 0); // Receive Fifo Empty

                if (uart.output.writableLength() == uart.output.buf.len)
                    status |= (1 << 1); // Send Fifo Empty

                if (uart.input.readableLength() == uart.input.buf.len)
                    status |= (1 << 2); // Receive Fifo Full

                if (uart.output.writableLength() == 0)
                    status |= (1 << 3); // Send Fifo Full

                // no frame errors for our serial ports in emulation

                break :blk status;
            },
            else => return error.BusError,
        };
    }

    fn write16(busdev: *BusDevice, address: u24, value: u16) BusDevice.Error!void {
        const uart = @fieldParentPtr(Self, "bus_device", busdev);
        switch ((address & 0x7FF) >> 1) {
            0 => uart.output.writeItem(@truncate(u8, value)) catch return error.BusError, // TODO: write sent characters here
            else => return error.BusError,
        }
    }
};
comptime {
    std.debug.assert(@bitSizeOf(MMU.Register) == 16);
    std.debug.assert(@sizeOf(MMU.Register) == 2);
    std.debug.assert(@bitSizeOf(VGA.RGB) == 16);
    std.debug.assert(@sizeOf(VGA.RGB) == 2);
}

const hexfont_8x8 = [16][7]u8{
    [7]u8{
        0b11111,
        0b10001,
        0b10001,
        0b10001,
        0b10001,
        0b10001,
        0b11111,
    },
    [7]u8{
        0b00001,
        0b00001,
        0b00001,
        0b00001,
        0b00001,
        0b00001,
        0b00001,
    },
    [7]u8{
        0b11111,
        0b00001,
        0b00001,
        0b11111,
        0b10000,
        0b10000,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b00001,
        0b00001,
        0b11111,
        0b00001,
        0b00001,
        0b11111,
    },
    [7]u8{
        0b10001,
        0b10001,
        0b10001,
        0b11111,
        0b00001,
        0b00001,
        0b00001,
    },
    [7]u8{
        0b11111,
        0b10000,
        0b10000,
        0b11111,
        0b00001,
        0b00001,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b10000,
        0b10000,
        0b11111,
        0b10001,
        0b10001,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b00001,
        0b00001,
        0b00111,
        0b00001,
        0b00001,
        0b00001,
    },
    [7]u8{
        0b11111,
        0b10001,
        0b10001,
        0b11111,
        0b10001,
        0b10001,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b10001,
        0b10001,
        0b11111,
        0b00001,
        0b00001,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b10001,
        0b10001,
        0b11111,
        0b10001,
        0b10001,
        0b10001,
    },
    [7]u8{
        0b10000,
        0b10000,
        0b10000,
        0b11111,
        0b10001,
        0b10001,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b10000,
        0b10000,
        0b10000,
        0b10000,
        0b10000,
        0b11111,
    },
    [7]u8{
        0b00001,
        0b00001,
        0b00001,
        0b11111,
        0b10001,
        0b10001,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b10000,
        0b10000,
        0b11111,
        0b10000,
        0b10000,
        0b11111,
    },
    [7]u8{
        0b11111,
        0b10000,
        0b10000,
        0b11111,
        0b10000,
        0b10000,
        0b10000,
    },
};

fn isWordAlignedAddress(address: u24) bool {
    return (address & 1) == 0;
}

pub fn fileExtension(path: []const u8) ?[]const u8 {
    const filename = std.fs.path.basename(path);
    return if (std.mem.lastIndexOf(u8, filename, ".")) |index|
        if (index == 0 or index == filename.len - 1)
            null
        else
            filename[index + 1 ..]
    else
        null;
}
