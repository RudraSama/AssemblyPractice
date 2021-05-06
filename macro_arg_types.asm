section .data
digit db 0, 0xA
text: db "Hello", 0
section .text
global _start

%macro print 1
  %ifid %1
  mov rdi, %1
  call print_string
  %else
      %ifnum %1
      mov rdi, %1
      call print_num        ;0-9 only
      %else
      %error "String literals are not supported yet."
      %endif
  %endif
%endmacro


_start:
    print "hello"

    mov rax, 60
    mov rdi, 0
    syscall

str_len:
    mov rax, 0
.loop:
    cmp byte [rdi+rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret
print_string:
    push rdi
    call str_len
    pop rsi
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    ret


print_num:
    mov rax, rdi
    add rax, 48
    mov [digit], al
    mov rax, 1
    mov rsi, digit
    mov rdx, 1
    mov rdi, 1
    syscall
    ret
