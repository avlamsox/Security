global _start

section .text

exit_gracefully:
	xor rax, rax
	add rax, 60
	mov rdi, 1
	syscall

_start:
	jmp main

main:
	xor rax, rax
	mov rax, 2
	lea rdi, [file_name]
	mov rsi, 1
	mov rdx, 1
	syscall

	mov [fd_out], rax

	xor rax, rax
	mov rax, 4
	mov rbx , [fd_out]
	mov rcx, file_data
	mov rdx, data_len
	syscall
	
	jmp exit_gracefully

section .data
	file_name db 'stage2.mlwr'
	file_data db 'Hi I am stage2 malware'
	data_len equ $-file_data

section .bss
	fd_out resw 1
