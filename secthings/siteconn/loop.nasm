global _start

section .bss
	

section .text

_start:
	mov rcx, 20

printHw:
;	push rcx	
	mov rax, 1
	mov rdi, 1
	mov rsi, welcome
	mov rdx, 8
	syscall	
;	pop rcx

	loop printHw

	xor rax, rax
	mov rax, 60	
	mov rdi, 1
	syscall

section .data:
	welcome: db 'Hey you', 0xa
