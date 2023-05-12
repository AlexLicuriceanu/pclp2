section .text
	global sort

struc node
    val:    resd 1
    next:	resd 1
endstruc

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	mov	esi, [ebp + 8] 		; n
	mov	edi, [ebp + 12] 	; vectorul de structuri
	mov ebx, esi 			; ebx itereaza de la n la 1

nodes_loop:
	mov ecx, esi	; muta valoarea n din esi in ecx
	xor edx, edx	; reset edx cu care iteram peste nodurile nesortate

	; iteram peste toate nodurile si le cautam in ordine descrescatoare, punandu-le pe stiva
	node_search:
		lea eax, [edi + edx * node_size]	; in eax punem pointerul nodului de indice edx
		cmp ebx, [eax + val]				; compara valoarea din eax cu valoarea cautata din ebx
		je found							; daca sunt egale, sari la found
		inc edx								; daca nu sunt egale, se incrementeaza edx
		cmp ecx, 0							; verifica daca am ajuns la ultimul nod
		dec ecx								; decrementeaza iteratorul pentru nodes_loop
		jne node_search						; daca nu am iterat peste toate nodurile, cicleaza node_search

	found:
		push eax 			; punem nodul pe stiva
		dec	ebx				; decrementam iteratorul
		cmp ebx, 0			; daca mai sunt noduri de sortat,
		jne nodes_loop		; cicleaza nodes_loop


	; dupa ce au fost puse toate nodurile pe stiva:	
	pop eax 		; scoatem primul nod (minim) de pe stiva
	xor edx, edx	; reset edx
	xor ecx, ecx	; reset ecx
	mov edx, eax 	; in edx salvam nodul de la pasul anterior
	mov ecx, esi	; ecx contorizeaza
	dec ecx			; decrementam ecx pentru ca deja am rezolvat primul nod

	; in stiva sunt ordonate corect nodurile, mai trebuie doar conectate
	; legaturile intre ele (campurile next)
connect:
	pop ebx 				; scoatem urmatorul nod de pe stiva
	mov [edx + next], ebx 	; actualizam legatura de la nodul anterior
	mov edx, ebx 			; nodul anterior devine nodul curent
	dec ecx					; decrementam iteratorul
	cmp ecx, 0				; daca mai sunt noduri de parcurs,
	jne connect				; cicleaza connect
	
	leave
	ret