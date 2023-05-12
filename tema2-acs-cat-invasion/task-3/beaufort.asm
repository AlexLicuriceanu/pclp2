%include "../include/io.mac"

section .text
    global beaufort
    extern printf
section .data
    plain_len dd 0

; void beaufort(int len_plain, char *plain, int len_key, char *key, char tabula_recta[26][26], char *enc) ;
beaufort:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov ecx, [ebp + 8]  ; len_plain
    mov ebx, [ebp + 12] ; plain (address of first element in string)
    mov edx, [ebp + 16] ; len_key
    mov edi, [ebp + 20] ; key (address of first element in matrix) 
    mov eax, [ebp + 24] ; tabula_recta
    mov esi, [ebp + 28] ; enc 
    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    mov [plain_len], ecx
    xor eax, eax

plain_loop:

    mov al, byte[edi]   ; key
    mov ah, byte[ebx]   ; plain
    cmp al, ah
    jg gr
    jl lw
    je eq
    gr: ; key > lit
        mov byte[ebx], 'A'
        add byte[ebx], al
        sub byte[ebx], ah
        jmp cont
    lw: ; key < lit
        mov byte[ebx], 'Z'
        sub byte[ebx], ah
        add byte[ebx], al
        inc byte[ebx]
        jmp cont
    eq:
        mov byte[ebx], 'A'
        jmp cont
    cont:
    inc edi
    cmp byte[edi], 0x00
    je reset_key
    jmp continue_key

    reset_key:
    sub edi, edx

    continue_key:
    inc ebx

loop plain_loop

    xor ecx, ecx
    xor edx, edx

    mov ecx, plain_len
    mov edx, 0
    sub ebx, [ecx]
    
copy_bytes:
    cmp edx, dword[ecx]
    je finished

    xor eax, eax
    mov al, byte[ebx + edx]
    mov byte[esi+edx], al

    inc edx
    jmp copy_bytes

finished:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
