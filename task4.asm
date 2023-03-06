section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	push    ebp
	mov 	ebp, esp
	pusha

	xor	eax, eax		; eax trebuie sa fie 0 la apelare ca sa fie returnat vendor id
	cpuid

	mov	eax, dword [ebp + 8]
	mov 	[eax], ebx 
	mov 	dword[eax + 4], edx
	mov 	dword[eax + 8], ecx
	
	popa
	leave
	ret

;; void features(int *apic, int *rdrand, int *mpx, int *svm)
;
;  checks whether apic, rdrand and mpx / svm are supported by the CPU
;  MPX should be checked only for Intel CPUs; otherwise, the mpx variable
;  should have the value -1
;  SVM should be checked only for AMD CPUs; otherwise, the svm variable
;  should have the value -1
features:
	push    ebp
	mov 	ebp, esp
	pusha

	mov	eax, 1
	cpuid

	mov	ebx, dword [ebp + 8]	; adresa unde se gaseste valoarea lui apic
	mov	edi, 0
	mov	[ebx], edi

	mov	eax, 1			; se gaseste la bitul 9 in edx
	shl	eax, 9			;
	and 	eax, edx		;
	cmp	eax, 0			; daca eax e diferit de 0, atunci bitul 9 e 1
	je 	rdrand			; continua la rdrand
	mov	edi, 1			; marcheaza cu 1 daca exista
	mov	[ebx], edi

rdrand:
	mov	ebx, dword [ebp + 12]	; adresa unde se gaseste valoarea lui rdrand
	mov	edi, 0
	mov	[ebx], edi

	mov	eax, 1			; se gaseste la bitul 30 in ecx
	shl 	eax, 30			;
	and	eax, ecx		;
	cmp	eax, 0			; daca eax e diferit de 0, atunci bitul 30 e 1
	je	exit			; continua la exit
	mov	edi, 1			; marcheaza cu 1 daca exista
	mov	[ebx], edi

exit:
	popa
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	push    ebp
	mov 	ebp, esp
	pusha
		
	mov	eax, 4
	mov	ecx, 2			; mentionam ca vrem de la nivelul 2

	cpuid

	mov	edx, dword [ebp + 8]	; primii 11 biti semnifica dimensiunea linie, adunat cu 1
	mov	eax, 2047
	and	eax, ebx
	add	eax, 1
	mov	[edx], eax	

	popa
	leave
	ret
