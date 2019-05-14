global _start
section .text

output:
        xor rax, rax 
        mov al, 1
        mov rdi, rax 
        mov rsi, printok
        mov rdx, 15
        syscall

exit_gracefully:
        ;exit syscall
        xor rax, rax 
        add rax, 60
        xor rdi, rdi 
        syscall

_start:
	jmp compare

compare:
	cld
	lea rsi, [fixedpass]
	lea rdi, [userpass]
	cmpsq
	jz output

	jmp exit_gracefully
	

section .data
	fixedpass: dq '1234', 0xa
	userpass: dq '1234', 0xa
	printok: dq 'just some print', 0xa
