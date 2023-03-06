section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:

	push    ebp				; salvare ebp pe stiva
	push 	esp
	pop 	ebp

	push 	dword [ebp + 8]  		; parametru a
	push	eax
	push 	dword [ebp + 12] 		; parametru b
	pop 	esi

	push 	eax			
	mul 	esi				; calculare produs a*b in eax
	pop	edi				; scoate a de pe stiva

compare:
	cmp 	edi, esi		 	; compara a cu b
	je	exit			 	; daca a=b, atunci s-a gasit cmmdc 
	jg	bigger			 
	
	sub	esi, edi   		 	; scade din b a
	jmp 	compare			 	

bigger:
	sub     edi, esi		 	; scade din a b
	jmp	compare				

exit:
	div 	edi				; calculare a*b/cmmdc = cmmmc

	push    ebp
	pop 	esp
	pop	ebp
	ret
