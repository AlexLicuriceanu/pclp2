global get_words
global compare_func
global sort

section .data
    delim db " .,", 10, 0

section .text
    extern strtok
    extern strcmp
    extern strlen
    extern qsort

compare_func:
    enter 0, 0

    push ebx
    push esi
    push edi

    mov eax, [ebp + 8]      ; punem primul cuvant in eax
    mov ebx, [ebp + 12]     ; punem al doilea cuvant in ebx
    mov esi, [eax]      ; punem adresele cuvintelor
    mov edi, [ebx]      ; in esi si edi

    ; pentru al doilea cuvant:
    push esi    ; punem adresele
    push edi    ; pe stiva
    push edi    ; punem parametrul lui strlen pe stiva
    call strlen ; apelam
    add esp, 4

    pop edi
    pop esi
    push eax    ; adaugam valoarea returnata de strlen pe stiva
   
    ; pentru primul cuvant:
    push esi    ; salvam adresele
    push edi    ; pe stiva
    push esi    ; punem parametrul lui strlen pe stiva
    call strlen ; apelam
    add esp, 4

    pop edi
    pop esi
    pop ebx         ; scoatem de pe stiva lungimea pentru al doilea cuvant
    sub eax, ebx    ; scadem lungimile
    jnz exit_compare_func   ; daca diferenta nu este 0, returneaz-o, altfel
    ; daca diferenta este 0, sirurile au aceeasi lungime, trebuie apelat strcmp pentru
    ; compararea lexicografica

    push edi    ; punem pe stiva
    push esi    ; parametrii lui strcmp
    call strcmp ; apelam
    add esp, 8

exit_compare_func: 
    pop edi
    pop esi
    pop ebx
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0

    mov	edi, [ebp + 8]      ; char **words
	mov ecx, [ebp + 12]     ; int number_of_words
    mov ebx, [ebp + 16]     ; int size

    ;void qsort(void *base, size_t nitems, size_t size, int (*compar)(const void *, const void*))
    push compare_func   ; punem functia de comparare pe stiva
    push ebx            ; punem size pe stiva
    push ecx            ; punem number_of_words pe stiva
    push edi            ; punem words pe stiva
    call qsort          ; apelam quicksort
    add esp, 16
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov	esi, [ebp + 8]      ; char *s
	mov	edi, [ebp + 12]     ; char **words
    mov ecx, [ebp + 16]     ; int number_of_words
    push ecx
    push edi

    push delim      ; punem pe stiva
    push esi        ; parametrii lui strtok
    call strtok     ; apelam
    add esp, 8  
    pop edi
    pop ecx

    xor ebx, ebx    ; reset ebx, iteratorul pt. words
    mov [edi + ebx * 4], eax    ; punem cuvantul in words
    inc ebx                     ; incrementam iteratorul lui words

add_words:      ; adaugam restul cuvintelor in words
    push ecx
    push edi
    push ebx

    push delim      ; punem parametrii pt. strtok pe stiva
    push 0
    call strtok     ; apelam
    add esp, 8      
    pop ebx
    pop edi
    pop ecx

    mov [edi + ebx * 4], eax    ; punem cuvantul in words
    inc ebx                     ; incrementam iteratorul lui words
    loop add_words              ; daca mai sunt cuvinte, cicleaza

exit:
    leave
    ret
    