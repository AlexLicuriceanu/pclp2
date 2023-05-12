section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0
	; v1 = rdi, n1 = rsi
	; v2 = rdx, n2 = rcx
	; v = r8
	xor rax, rax
	xor r9, r9		; contor v1
	xor r10, r10	; contor v2
	xor r11, r11 	; contor v
	xor r12, r12	; dimensiunea lui v (n1 + n2)
	add r12d, esi
	add r12d, ecx 

start:
	cmp r11d, r12d	; iteram peste fiecare pozitie din v
	je exit			; daca am ajuns la final, iesi din bucla

	check_v1:
		cmp r9d, esi	; verifica daca mai sunt elemente in v1
		jge check_v2	; daca nu mai exista, sari la check_v2
		xor eax, eax				
		mov eax, dword[rdi + 4 * r9]	; copiaza un element din v1 in eax
		mov dword[r8 + 4 * r11], eax	; pune eax in v
		inc r9		; incrementam indexul lui v1
		inc r11		; incrementam indexul lui v

	check_v2:
		cmp r10d, ecx	; verifica daca mai sunt elemente in v2
		jge next		; daca nu mai exista, sari la next (start)
		xor eax, eax
		mov eax, dword[rdx + 4 * r10]	; copiaza un element din v2 in eax
		mov dword[r8 + 4 * r11], eax	; pune eax in v
		inc r10		; incrementeaza indexul lui v2
		inc r11		; incrementeaza indexul lui v

	next:
	jmp start

exit:
	leave
	ret