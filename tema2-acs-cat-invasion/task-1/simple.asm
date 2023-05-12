%include "../include/io.mac"

section .text
    global simple
    extern printf
section .data
    counter db 2

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here
string_loop:
    lodsb

    mov ebx, 0
    caesar_loop:
        cmp ebx, edx
        je caesar_exit
        inc al
        inc ebx

        cmp al, 'Z'
        jle caesar_loop

        mov al, 'A'
        jmp caesar_loop

    caesar_exit:
    stosb
    loop string_loop         
    cld
    rep movsb

    ;; Your code ends here
    ;; DO NOT MODIFY
    popa
    leave
    ret
    
    ;; DO NOT MODIFY
