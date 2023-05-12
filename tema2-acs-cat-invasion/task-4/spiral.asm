%include "../include/io.mac"

section .text
    global spiral
    extern printf
section .data
    plain_size dd 0
    plain dd 0
    line_size dd 0
    matr_offset dd 0
    top dd 0
    bottom dd 0
    left dd 0
    right dd 0
    direction dd 0

; void spiral(int N, char *plain, int key[N][N], char *enc_string);
spiral:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov ecx, [ebp + 8]  ; N (size of key line)
    mov esi, [ebp + 12] ; plain (address of first element in string)
    mov ebx, [ebp + 16] ; key (address of first element in matrix)
    mov edi, [ebp + 20] ; enc_string (address of first element in string)
    
    mov [plain], esi
    mov eax, ecx
    mov [line_size], eax

    imul eax, ecx
    mov ecx, eax
    mov [plain_size], ecx
    xor eax, eax

    ; muta bytii din esi in edi decrementeaza ecx
copy_bytes:
    lodsb
    stosb
loop copy_bytes
    cld
    rep movsb

    mov ecx, plain_size
    sub edi, [ecx]  ; edi pointeaza catre inceput
    
    mov dword[top], 0
    mov dword[left], 0

    mov eax, [line_size]
    dec eax
    mov [bottom], eax
    mov [right], eax
    mov dword[direction], 1 ; left right

    xor eax, eax
    mov eax, [ecx]

    xor ecx, ecx
    xor eax, eax
    xor edx, edx

string_loop:
    mov eax, [top]
    mov ecx, [bottom]
    cmp eax, ecx
    jle next_cond
    jmp exit_string_loop

    next_cond:
    mov eax, [left]
    mov ecx, [right]
    cmp eax, ecx
    jg exit_string_loop
    
    
    check_left_right:
        cmp dword[direction], 1
        jne check_top_bottom

        xor eax, eax
        xor ecx, ecx
        xor edx, edx
        mov eax, [left]
        mov ecx, [right]

        for_left_right:    
            cmp eax, ecx
            jg exit_for_left_right

            mov edx, [line_size]
            imul edx, [top]
            add edx, eax
            imul edx, 4
            
            mov [matr_offset], edx
            mov edx, [ebx + edx]
            add [edi], edx

            inc edi
            inc eax
            jmp for_left_right

        exit_for_left_right:
            inc dword[top]
            mov dword[direction], 2
            jmp string_loop
        
    check_top_bottom:
        cmp dword[direction], 2
        jne check_right_left

        xor eax, eax
        xor ecx, ecx
        xor edx, edx
        mov eax, [top]
        mov ecx, [bottom]

        for_top_bottom:
            cmp eax, ecx
            jg exit_for_top_bottom

            mov edx, [line_size]
            imul edx, eax
            add edx, [right]
            imul edx, 4
            
            mov [matr_offset], edx
            mov edx, [ebx + edx]
            add [edi], edx
            
            inc edi
            inc eax
            jmp for_top_bottom

        exit_for_top_bottom:
            dec dword[right]
            mov dword[direction], 3
            jmp string_loop


    check_right_left:
        cmp dword[direction], 3
        jne check_bottom_top

        xor eax, eax
        xor ecx, ecx
        xor edx, edx
        mov eax, [right]
        mov ecx, [left]

        for_right_left:    
            cmp eax, ecx
            jl exit_for_right_left
            
            mov edx, [line_size]
            imul edx, [bottom]
            add edx, eax
            imul edx, 4
            
            mov [matr_offset], edx
            mov edx, [ebx + edx]
            add [edi], edx

            inc edi
            dec eax
            jmp for_right_left

        exit_for_right_left:
            dec dword[bottom]
            mov dword[direction], 4
            jmp string_loop

    check_bottom_top:
        cmp dword[direction], 4
        jne string_loop

        xor eax, eax
        xor ecx, ecx
        xor edx, edx
        mov eax, [bottom]
        mov ecx, [top]

        for_bottom_top:    
            cmp eax, ecx
            jl exit_for_bottom_top
            
            mov edx, [line_size]
            imul edx, eax
            add edx, [left]
            imul edx, 4
            
            mov [matr_offset], edx
            mov edx, [ebx + edx]
            add [edi], edx

            inc edi
            dec eax
            jmp for_bottom_top

        exit_for_bottom_top:
            inc dword[left]
            mov dword[direction], 1
            jmp string_loop

exit_string_loop:

    ;; DO NOT MODIFY
    ;; TODO: Implement spiral encryption
    ;; FREESTYLE STARTS HERE
    

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
