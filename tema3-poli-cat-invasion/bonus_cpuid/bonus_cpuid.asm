section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string

; https://www.felixcloutier.com/x86/cpuid
; multe informatii despre cpuid utilizate in rezolvare
cpu_manufact_id:
	enter 0, 0
	
	push ebx
	xor eax, eax
	xor ecx, ecx
	xor edx, edx
	cpuid
	mov eax, dword[ebp + 8]
	mov dword[eax], ebx
	mov dword[eax + 4], edx
	mov dword[eax + 8], ecx

	pop ebx
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise

features:
	enter 0, 0
	
	push ebx
	mov eax, 1
	cpuid
	
	xor edx, edx
	mov edx, 1
	shl edx, 5
	and edx, ecx
	cmp edx, 0
	
	je no_vmx
	mov edi, dword[ebp + 8]
	mov dword[edi], 1
	jmp next1

	no_vmx:
	mov edi, dword[ebp + 8]
	mov dword[edi], 0

next1:
	xor edx, edx
	mov edx, 1
	shl edx, 30
	and edx, ecx
	cmp edx, 0
	
	je no_rdrand
	mov edi, dword[ebp + 12]
	mov dword[edi], 1
	jmp next2

	no_rdrand:
	mov edi, dword[ebp+ 12]
	mov dword[edi], 0

next2:
	xor edx, edx
	mov edx, 1
	shl edx, 28
	and edx, ecx
	cmp edx, 0
	je no_avx
	mov edi, dword[ebp + 16]
	mov dword[edi], 1
	jmp exit_features

	no_avx:
	mov edi, dword[ebp + 16]
	mov dword[edi], 0

exit_features:
	pop ebx
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 0, 0
	
	push ebx
	mov eax, 4	; pregatim eax
	mov ecx, 2	; pregatim ecx
	cpuid		; apelam cpuid

	xor edx, edx
	mov edx, 4095
	and edx, ebx
	inc edx
	mov eax, dword[ebp + 8]
	mov dword[eax], edx

; pentru a calcula L2 cache size, avem urmatoarea metoda:
; Cache size = (Ways + 1) * (Partitions + 1) * (Line_Size + 1) * (Sets + 1)
; in eax avem Line_size + 1, iar in ecx avem Sets + 1
	mov eax, edx
	inc ecx
	imul eax, ecx 	; eax = (Line_Size + 1) * (Sets + 1)

; pentru Partitions, folosim masca pe bitii dintre 12 si 21
	xor edx, edx			; reset edx
	mov edx, 4190208		; formam masca
	and edx, ebx			; aplicam masca
	inc edx					; ne trebuie Partitions + 1
	imul eax, edx			; eax = (Partitions + 1) * (Line_Size + 1) * (Sets + 1)

; pentru Ways, folosim masca pe bitii dintre 22 si 31
	xor edx, edx			; reset edx
	mov edx, 4290772992		; formam masca
	and edx, ebx			; aplicam masca
	inc edx					; ne trebuie Ways + 1
	imul eax, edx			; eax = (Ways + 1) * (Partitions + 1) * (Line_Size + 1) * (Sets + 1)
	
	div eax, 8		; se cere dimensiunea in bytes

	mov edx, dword[ebp + 12]
	mov dword[edx], eax
	pop ebx
	leave
	ret
