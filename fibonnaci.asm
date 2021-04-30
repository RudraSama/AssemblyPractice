%define O_RONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .bss
  digitSpace resb 100
  digitSpacePos resb 4
section .data
section .text
fname: db 'value.txt', 0
global _start

_start:
    call _mmap
    call _str2int
    mov rsi, rax
    mov rdx, 0
    mov rbx, 1
    mov rax, 0
    call _printFib
    call _printRAX

    mov rax, 60
    mov rdi, 0
    syscall

_printFib:
    mov rcx, 0
.loop:
    mov rax, rdx
    add rax, rbx
    inc rcx

    mov rdx, rbx
    mov rbx, rax
    cmp rcx, rsi
    je .end
    jmp .loop


.end:
    ret


_mmap:
    mov rax, 2
    mov rdi, fname
    mov rsi, O_RONLY     ;open file read only
    mov rdx, 0           ;we are not creating file so this argument has not meaning
    syscall

    ;mmap
    mov r8, rax          ;rax hold opened file discriptor, It is the fourth argument of mmap
    mov rax, 9           ;mpa number
    mov rdi, 0           ;operating system will choose mapping destination
    mov rsi, 4096        ;page size
    mov rdx, PROT_READ   ;new memory region will be marked read only
    mov r10, MAP_PRIVATE ;page will not be shared

    mov r9, 0            ;offset inside test.txt
    syscall
    mov rdi, rax
    ret

_printRAX:
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx
_printRAXLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48

    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx

    pop rax
    cmp rax, 0
    jne _printRAXLoop

_printRAXLoop2:
    mov rcx, [digitSpacePos]
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall

    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx

    cmp rcx, digitSpace
    jge _printRAXLoop2
    ret

_str2int:
    mov rcx, 0
    mov rax, 0
    mov rbx, 10
    cmp byte[rdi+rcx+1], 10
    je .ones
.loop:
    cmp byte[rdi+rcx], 10
    je .end2
    push rbx
    movzx rbx, byte[rdi+rcx]
    inc rcx
    add rax, rbx
    pop rbx
    sub rax, 48
    cmp byte[rdi+rcx], 10
    je .end2
    mul rbx
    jmp .loop

.ones:
    movzx rax, byte[rdi]
    sub rax, 48
    ret
.end2:
    ret
