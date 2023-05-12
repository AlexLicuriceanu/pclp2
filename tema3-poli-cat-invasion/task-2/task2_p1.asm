section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	push ebx
    push dword [esp + 8]	; punem valoarea a pe stiva 
    pop eax					; extragem a-ul de pe stiva in eax 
    push dword [esp + 12]	; punem valoarea b pe stiva
    pop ebx 				; extragem b-ul de pe stiva in ebx

start:
    cmp eax, ebx	; compara a cu b
    jl lower		; daca a < b
    jg greater		; daca a > b
    jmp check_equal	

lower:
    sub ebx, eax	; ebx = ebx - eax
    jmp check_equal

greater:
    sub eax, ebx	; eax = eax - ebx
	jmp check_equal

check_equal:
    cmp eax, ebx
    jne start

exit:
	xor eax, eax
	inc eax
	imul eax, dword[esp + 8]
	imul eax, dword[esp + 12]

	xor edx, edx
	div ebx

	pop ebx
    ret