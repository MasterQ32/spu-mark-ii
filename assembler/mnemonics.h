// Stack Operations
MNEMONIC(nop,    0, INPUT_ZERO, INPUT_ZERO, CMD_COPY,    OUTPUT_DISCARD, 0)
MNEMONIC(push,   1, INPUT_ARG,  INPUT_ZERO, CMD_COPY,    OUTPUT_PUSH,    0)
MNEMONIC(pop,    0, INPUT_POP,  INPUT_ZERO, CMD_COPY,    OUTPUT_DISCARD, 0)
MNEMONIC(dup,    0, INPUT_PEEK, INPUT_ZERO, CMD_COPY,    OUTPUT_PUSH,    0)

// Jumps
MNEMONIC(jmp,    1, INPUT_ARG,  INPUT_ZERO, CMD_COPY,    OUTPUT_JUMP,    0)
MNEMONIC(rjmp,   1, INPUT_ARG,  INPUT_ZERO, CMD_COPY,    OUTPUT_RJUMP,   0)

// Indirect jumps
MNEMONIC(jmpi,   0, INPUT_POP,  INPUT_ZERO, CMD_COPY,    OUTPUT_JUMP,    0)
MNEMONIC(ret,    0, INPUT_POP,  INPUT_ZERO, CMD_COPY,    OUTPUT_JUMP,    0)

// direct memory access
MNEMONIC(ld8,    1, INPUT_ARG,  INPUT_ZERO, CMD_LOAD8,   OUTPUT_PUSH,    0)
MNEMONIC(ld,     1, INPUT_ARG,  INPUT_ZERO, CMD_LOAD16,  OUTPUT_PUSH,    0)
MNEMONIC(st8,    1, INPUT_ARG,  INPUT_ZERO, CMD_STOR8,   OUTPUT_DISCARD, 0)
MNEMONIC(st,     1, INPUT_ARG,  INPUT_ZERO, CMD_STOR16,  OUTPUT_DISCARD, 0)

// indirect memory access
MNEMONIC(ld8i,   0, INPUT_POP,  INPUT_ZERO, CMD_LOAD8,   OUTPUT_PUSH,    0)
MNEMONIC(ldi,    0, INPUT_POP,  INPUT_ZERO, CMD_LOAD16,  OUTPUT_PUSH,    0)
MNEMONIC(st8i,   0, INPUT_POP,  INPUT_ZERO, CMD_STOR8,   OUTPUT_DISCARD, 0)
MNEMONIC(sti,    0, INPUT_POP,  INPUT_ZERO, CMD_STOR16,  OUTPUT_DISCARD, 0)

// direct stack access
MNEMONIC(get,    1, INPUT_ARG,  INPUT_ZERO, CMD_GET,    OUTPUT_PUSH,     0)
MNEMONIC(set,    1, INPUT_ARG,  INPUT_POP,  CMD_SET,    OUTPUT_DISCARD,  0)

// indirect stack access
MNEMONIC(geti,   0, INPUT_POP,  INPUT_ZERO, CMD_GET,    OUTPUT_PUSH,     0)
MNEMONIC(seti,   0, INPUT_POP,  INPUT_POP,  CMD_SET,    OUTPUT_DISCARD,  0)

// register access
MNEMONIC(cpget,  0, INPUT_ZERO, INPUT_ZERO, CMD_CPGET,  OUTPUT_PUSH,     0)
MNEMONIC(cpget,  1, INPUT_ARG,  INPUT_ZERO, CMD_CPGET,  OUTPUT_PUSH,     0)
MNEMONIC(spget,  0, INPUT_ZERO, INPUT_ZERO, CMD_SPGET,  OUTPUT_PUSH,     0)
MNEMONIC(bpget,  0, INPUT_ZERO, INPUT_ZERO, CMD_BPGET,  OUTPUT_PUSH,     0)

MNEMONIC(bpset,  0, INPUT_POP,  INPUT_ZERO, CMD_BPSET,  OUTPUT_DISCARD,  0)
MNEMONIC(spset,  0, INPUT_POP,  INPUT_ZERO, CMD_SPSET,  OUTPUT_DISCARD,  0)

MNEMONIC(bpset,  1, INPUT_ARG,  INPUT_ZERO, CMD_BPSET,  OUTPUT_DISCARD,  0)
MNEMONIC(spset,  1, INPUT_ARG,  INPUT_ZERO, CMD_SPSET,  OUTPUT_DISCARD,  0)

// binary arithmetic
MNEMONIC(add,    0, INPUT_POP,  INPUT_POP,  CMD_ADD,    OUTPUT_PUSH,     0)
MNEMONIC(sub,    0, INPUT_POP,  INPUT_POP,  CMD_SUB,    OUTPUT_PUSH,     0)
MNEMONIC(mul,    0, INPUT_POP,  INPUT_POP,  CMD_MUL,    OUTPUT_PUSH,     0)
MNEMONIC(div,    0, INPUT_POP,  INPUT_POP,  CMD_DIV,    OUTPUT_PUSH,     0)
MNEMONIC(mod,    0, INPUT_POP,  INPUT_POP,  CMD_MOD,    OUTPUT_PUSH,     0)

MNEMONIC(and,    0, INPUT_POP,  INPUT_POP,  CMD_AND,    OUTPUT_PUSH,     0)
MNEMONIC(or,     0, INPUT_POP,  INPUT_POP,  CMD_OR,     OUTPUT_PUSH,     0)
MNEMONIC(xor,    0, INPUT_POP,  INPUT_POP,  CMD_XOR,    OUTPUT_PUSH,     0)

// direct arithmetic
MNEMONIC(add,    1, INPUT_POP,  INPUT_ARG,  CMD_ADD,    OUTPUT_PUSH,     0)
MNEMONIC(sub,    1, INPUT_POP,  INPUT_ARG,  CMD_SUB,    OUTPUT_PUSH,     0)
MNEMONIC(mul,    1, INPUT_POP,  INPUT_ARG,  CMD_MUL,    OUTPUT_PUSH,     0)
MNEMONIC(div,    1, INPUT_POP,  INPUT_ARG,  CMD_DIV,    OUTPUT_PUSH,     0)
MNEMONIC(mod,    1, INPUT_POP,  INPUT_ARG,  CMD_MOD,    OUTPUT_PUSH,     0)

MNEMONIC(and,    1, INPUT_POP,  INPUT_ARG,  CMD_AND,    OUTPUT_PUSH,     0)
MNEMONIC(or,     1, INPUT_POP,  INPUT_ARG,  CMD_OR,     OUTPUT_PUSH,     0)
MNEMONIC(xor,    1, INPUT_POP,  INPUT_ARG,  CMD_XOR,    OUTPUT_PUSH,     0)

// unary arithmetic
MNEMONIC(not,    0, INPUT_POP,  INPUT_ZERO, CMD_NOT,    OUTPUT_PUSH,     0)
MNEMONIC(neg,    0, INPUT_POP,  INPUT_ZERO, CMD_NEG,    OUTPUT_PUSH,     0)
MNEMONIC(rol,    0, INPUT_POP,  INPUT_ZERO, CMD_ROL,    OUTPUT_PUSH,     0)
MNEMONIC(ror,    0, INPUT_POP,  INPUT_ZERO, CMD_ROR,    OUTPUT_PUSH,     0)
MNEMONIC(asl,    0, INPUT_POP,  INPUT_ZERO, CMD_LSL,    OUTPUT_PUSH,     0)
MNEMONIC(asr,    0, INPUT_POP,  INPUT_ZERO, CMD_ASR,    OUTPUT_PUSH,     0)
MNEMONIC(lsl,    0, INPUT_POP,  INPUT_ZERO, CMD_LSL,    OUTPUT_PUSH,     0)
MNEMONIC(lsr,    0, INPUT_POP,  INPUT_ZERO, CMD_LSR,    OUTPUT_PUSH,     0)

// Comparison
MNEMONIC(cmp,    0, INPUT_POP,  INPUT_POP,  CMD_SUB,    OUTPUT_DISCARD,  1)
MNEMONIC(test,   1, INPUT_POP,  INPUT_ARG,  CMD_SUB,    OUTPUT_DISCARD,  1)

// I/O
MNEMONIC(out,    1, INPUT_ARG,  INPUT_POP,  CMD_OUTPUT, OUTPUT_DISCARD,  0)
MNEMONIC(outi,   0, INPUT_POP,  INPUT_POP,  CMD_OUTPUT, OUTPUT_DISCARD,  0)

MNEMONIC(in,     1, INPUT_ARG,  INPUT_ZERO, CMD_INPUT,  OUTPUT_PUSH,     0)
MNEMONIC(ini,    0, INPUT_POP,  INPUT_ZERO, CMD_INPUT,  OUTPUT_PUSH,     0)

// Interrupts
MNEMONIC(int,    1, INPUT_ARG,  INPUT_ZERO, CMD_INT,    OUTPUT_DISCARD,  0)
MNEMONIC(setint, 1, INPUT_ARG,  INPUT_ZERO, CMD_SETINT, OUTPUT_DISCARD,  0)