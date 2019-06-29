global _start
section .text

_start:
	jmp main


exec_new_program:
	pop rdi
	xor rax, rax
	add rax, 59
	xor rdx, rdx
	syscall
	
main:
	call exec_new_program
	program_name: db './s2.py', 0x0
	;program_name: db './x2st', 0x0
