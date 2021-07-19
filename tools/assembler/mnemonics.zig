usingnamespace @import("spu-mk2");

pub const Mnemonic = struct {
    name: []const u8,
    argc: usize,
    instruction: Instruction,
};

pub const mnemonics = [_]Mnemonic{
    Mnemonic{ .name = "nop", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .copy, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "push", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .copy, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "pop", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .copy, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "dup", .argc = 0, .instruction = .{ .condition = .always, .input0 = .peek, .input1 = .zero, .command = .copy, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "replace", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .pop, .command = .copy, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ld8", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .load8, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ld", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .load16, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "st8", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .store8, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .store16, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st8", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .store8, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .store16, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "ld8", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .load8, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ld", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .load16, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "st8", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .store8, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .store16, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "get", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .get, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "set", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .pop, .command = .set, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "geti", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .get, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "seti", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .set, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "spget", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .spget, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "bpget", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .bpget, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "bpset", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .bpset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "spset", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .spset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "bpset", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .bpset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "spset", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .spset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "frget", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .frget, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "frset", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .frset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "frset", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .frset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "frset", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .frset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "add", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .add, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "sub", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .sub, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mul", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .mul, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "div", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .div, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mod", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .mod, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "and", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .@"and", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "and", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"and", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "or", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .@"or", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "or", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"or", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "xor", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .xor, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "xor", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"xor", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "add", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .add, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "sub", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .sub, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mul", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .mul, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "div", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .div, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mod", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .mod, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "and", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"and", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "or", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"or", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "xor", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .xor, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "not", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .not, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "neg", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .pop, .command = .sub, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "rol", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .rol, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ror", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .ror, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "asl", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .lsl, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "asr", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .asr, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "lsl", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .lsl, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "lsr", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .lsr, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "bswap", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .bswap, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "cmp", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .sub, .output = .discard, .modify_flags = true } },
    Mnemonic{ .name = "cmp", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .sub, .output = .discard, .modify_flags = true } },
    Mnemonic{ .name = "cmpp", .argc = 1, .instruction = .{ .condition = .always, .input0 = .peek, .input1 = .immediate, .command = .sub, .output = .discard, .modify_flags = true } },
    Mnemonic{ .name = "sgnext", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .signext, .output = .push, .modify_flags = false } },

    Mnemonic{ .name = "jmp", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .setip, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "jmp", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .setip, .output = .discard, .modify_flags = false } },

    Mnemonic{ .name = "call", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .setip, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "call", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .setip, .output = .push, .modify_flags = false } },

    // Alias for jmp
    Mnemonic{ .name = "ret", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .setip, .output = .discard, .modify_flags = false } },

    Mnemonic{ .name = "iret", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .setip, .output = .discard, .modify_flags = false } },

    Mnemonic{ .name = "intr", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .intr, .output = .discard, .modify_flags = false } },
};
