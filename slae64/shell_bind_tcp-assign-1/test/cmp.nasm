
global _start

section .data:
	;passcode: dq 'passme'
	userpass: dq 1234
	printok: db 'just some print', 0xa
	readbuf: times 64 db 0
        lenbuf: equ $-readbuf

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

compare:
;	xor rax, rax 
 ;       mov al, 0; syscall num for read
  ;      mov rdi, 0; fd for stdin
   ;     mov rsi, readbuf
    ;    mov rdx, lenbuf
     ;   syscall

	mov rax, 0x1234
	lea rdi, [userpass]
	scasq 
	jz output
	
	jmp exit_gracefully

_start:
	call compare
