section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	push ebx
	push ecx
	push edx
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	push dword [esp + 20]	; sirul pus pe stiva
	pop eax					; sirul pus in eax de pe stiva

start:
	push dword[eax + ecx]
	pop ebx
	cmp bl, '('		; comparam 1 byte din ebx cu '('
	je left			; daca bl = '(' sari la left
	jmp right		; daca bl = ')' sari la right

	left:
		inc edx
		jmp next
		cmp edx, 0
		jl exit_0
	right:
		dec edx
		cmp edx, 0
		jl exit_0

	next:
		inc ecx
		cmp ecx, dword[esp + 16]	; nr. de caractere
		jl start
		
		cmp edx, 0
		je exit_1

exit_0:
	push 0
	pop eax
	pop ebx
	pop ecx
	pop edx
	ret 

exit_1:
	push 1
	pop eax
	pop ebx
	pop ecx
	pop edx
	ret