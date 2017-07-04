#pragma once
#include <stdint.h>
#include <stdbool.h>

#ifdef TRACE

void trace_init();

void trace_instr(uint16_t addr, uint16_t instr, uint16_t top, int flags, bool exec);

void trace_result(uint16_t result);

void trace_intr(uint16_t intr);

#else

#define trace_init()
#define trace_instr(addr, instr, top, flags, exec)
#define trace_result(result)
#define trace_intr(intr)

#endif