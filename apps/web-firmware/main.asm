.org 0x000
.dw entrypoint  ; Reset
.dw handler.nmi      ; NMI
.dw handler.bus      ; BUS
.dw 0x0000           ; RESERVED
.dw handler.arith    ; ARITH
.dw handler.software ; SOFTWARE
.dw 0x0000           ; RESERVED
.dw handler.irq      ; IRQ

.equ SERIAL_PORT, 0x7FFE
.equ RAM_START,   0x8000

handler.nmi:
	st 'N', SERIAL_PORT 
	st 'M', SERIAL_PORT 
	st 'I', SERIAL_PORT 
  iret

handler.bus:
	st 'B', SERIAL_PORT 
	st 'U', SERIAL_PORT 
	st 'S', SERIAL_PORT 
  jmp hang

handler.arith:
	st 'A', SERIAL_PORT
	st 'R', SERIAL_PORT
	st 'I', SERIAL_PORT
	st 'T', SERIAL_PORT
	st 'H', SERIAL_PORT
	iret

handler.software:
	st 'S', SERIAL_PORT
	st 'W', SERIAL_PORT
	st 'I', SERIAL_PORT
	iret

handler.irq:
	st 'I', SERIAL_PORT 
	st 'R', SERIAL_PORT 
	st 'Q', SERIAL_PORT 
	iret

entrypoint:
  spset 0x0000
  bpset 0x0000

  push init_msg

print_loop:
  ld8 [i0:peek] [f:yes]
  [ex:zero] jmp echo_loop [i1:pop]
  st SERIAL_PORT
  add 1
  jmp print_loop

echo_loop:
  ld SERIAL_PORT [f:yes]
  [ex:less] pop
  [ex:less] jmp echo_loop
  st SERIAL_PORT
  jmp echo_loop

hang:
  jmp hang

init_msg:
.asciiz "Hello, World!\r\n>"