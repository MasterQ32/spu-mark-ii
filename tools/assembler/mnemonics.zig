const spu = @import("spu-mk2");

pub const Mnemonic = struct {
    name: []const u8,
    info: []const u8 = "",
    argc: usize,
    instruction: spu.Instruction,
};

pub const mnemonics = [_]Mnemonic{
    Mnemonic{ .name = "nop", .info = "Does nothing", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .copy, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "push", .info = "Pushes a value", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .copy, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "pop", .info = "Removes the stack top", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .copy, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "dup", .info = "Duplicates the stack top", .argc = 0, .instruction = .{ .condition = .always, .input0 = .peek, .input1 = .zero, .command = .copy, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "replace", .info = "Removes the stack top and pushes a value", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .pop, .command = .copy, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ld8", .info = "Pushes the byte from the immediate address", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .load8, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ld", .info = "Pushes the word from the immediate address", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .load16, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "st8", .info = "Pops a byte and stores it at the immediate address", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .store8, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st", .info = "Pops a word and stores it at the immediate address", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .store16, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st8", .info = "Stores immediate byte at immediate address.", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .store8, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st", .info = "Stores immediate word at immediate address.", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .store16, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "ld8", .info = "Pops address, pushes byte at address", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .load8, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ld", .info = "Pops address, pushes word at address", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .load16, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "st8", .info = "Pops byte and address, stores it.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .store8, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "st", .info = "Pops word and address, stores it.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .store16, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "get", .info = "Reads a value from BP-relative offset", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .get, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "set", .info = "Writes a value to BP-relative offset", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .pop, .command = .set, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "get", .info = "Reads a value from BP-relative offset", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .get, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "set", .info = "Writes a value to BP-relative offset", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .set, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "set", .info = "Writes a value to BP-relative offset", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .set, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "spget", .info = "Pushes the current stack pointer", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .spget, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "bpget", .info = "Pushes the current base pointer.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .bpget, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "bpset", .info = "Pops a value and sets the base pointer to it.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .bpset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "spset", .info = "Pops a value and sets the stack pointer to it.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .spset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "bpset", .info = "Sets the base pointer to the immediate value.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .bpset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "spset", .info = "Sets the stack pointer to the immediate value.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .spset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "frget", .info = "Pushes the current flag register.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .frget, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "frget", .info = "Pushes the current flag register with mask.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .pop, .command = .frget, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "frset", .info = "Pops a value and sets the flag register to it.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .frset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "frset", .info = "Sets the flag register to the immediate value.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .frset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "frset", .info = "Sets the flag register to the first immediate value, where only the bits are changed that are 0 in the second immediate value.", .argc = 2, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .immediate, .command = .frset, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "add", .info = "Pops two values and pushes the sum of both.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .add, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "sub", .info = "Pops two values and pushes the difference of both.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .sub, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mul", .info = "Pops two values and pushes the product of both.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .mul, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "div", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .div, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mod", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .mod, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "and", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .@"and", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "and", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"and", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "or", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .@"or", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "or", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"or", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "xor", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .xor, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "xor", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"xor", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "add", .info = "Adds immediate to stack top.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .add, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "sub", .info = "Subtracts immediate from stack top.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .sub, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mul", .info = "Multiplies immediate and stack top.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .mul, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "div", .info = "Divides stack top by immediate.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .div, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "mod", .info = "Computes modulus of stack top % immediate", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .mod, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "and", .info = "", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"and", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "or", .info = "", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .@"or", .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "xor", .info = "", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .xor, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "not", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .not, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "neg", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .pop, .command = .sub, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "rol", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .rol, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "ror", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .ror, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "asl", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .lsl, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "asr", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .asr, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "lsl", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .lsl, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "lsr", .info = "", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .lsr, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "bswap", .info = "Swaps bytes of stack top", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .bswap, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "cmp", .info = "Compares two values from the stack.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .sub, .output = .discard, .modify_flags = true } },
    Mnemonic{ .name = "cmp", .info = "Compares stack top to immediate value", .argc = 1, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .immediate, .command = .sub, .output = .discard, .modify_flags = true } },
    Mnemonic{ .name = "cmpp", .info = "Compares stack top to immediate value, doesn't pop.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .peek, .input1 = .immediate, .command = .sub, .output = .discard, .modify_flags = true } },
    Mnemonic{ .name = "sgnext", .info = "Sign-extends stack top.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .signext, .output = .push, .modify_flags = false } },

    Mnemonic{ .name = "jmp", .info = "Pops address, jumps to it.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .setip, .output = .discard, .modify_flags = false } },
    Mnemonic{ .name = "jmp", .info = "Jumps to immediate address.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .setip, .output = .discard, .modify_flags = false } },

    Mnemonic{ .name = "call", .info = "Pops address and calls it.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .setip, .output = .push, .modify_flags = false } },
    Mnemonic{ .name = "call", .info = "Calls immediate address.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .setip, .output = .push, .modify_flags = false } },

    // Alias for jmp
    Mnemonic{ .name = "ret", .info = "Returns from a function call.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .zero, .command = .setip, .output = .discard, .modify_flags = false } },

    Mnemonic{ .name = "iret", .info = "Returns from a interrupt.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .pop, .input1 = .pop, .command = .setip, .output = .discard, .modify_flags = false } },

    Mnemonic{ .name = "intr", .info = "Invokes the given interrupts.", .argc = 1, .instruction = .{ .condition = .always, .input0 = .immediate, .input1 = .zero, .command = .intr, .output = .discard, .modify_flags = false } },

    Mnemonic{ .name = "halt", .info = "Halts the CPU until the next IRQ.", .argc = 0, .instruction = .{ .condition = .always, .input0 = .zero, .input1 = .zero, .command = .halt, .output = .discard, .modify_flags = false } },
};
