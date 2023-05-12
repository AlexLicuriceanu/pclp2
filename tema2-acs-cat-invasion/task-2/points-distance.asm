%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global points_distance
    extern printf

section .data
    pointArray: times point_size * 10 dw 0

points_distance:
    ;; DO NOT MODIFY
    
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; points
    mov eax, [ebp + 12]     ; distance
    ;; DO NOT MODIFY
    ;; Your code starts here

    xor edx, edx
    xor eax, eax
    xor ecx, ecx
    
    mov ecx, dword[ebx]

    PRINTF32 `%d\n\x0`, ecx
    ;; DO NOT MODIFY
    popa
    leave
    ret

    ;; DO NOT MODIFY