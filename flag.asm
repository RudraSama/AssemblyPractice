section .data
	hellostring: db "Hello",0xA

section .text
global _start


_start:
	%ifdef flag
		mov rax, 1
		mov rdi, 1
		mov rsi, hellostring
		mov rdx, 6
		syscall
	%endif

	mov rax, 60
	mov rdi, 0
	syscall
