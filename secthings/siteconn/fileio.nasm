global _start

section .text
	mov eax, 8
	mov ebx, file_name
	mov ecx, 0777
	syscall

	mov [fd_out], eax



section .data
	file_name db 'stage2.mlwr'

section .bss
	fd_out resb 1
