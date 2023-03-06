section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	push    ebp					; salvare ebp pe stiva
	push 	esp
	pop 	ebp

	push 	dword [ebp + 8]				; str_length
	pop 	ecx					;
	push 	dword [ebp + 12]			; str
	pop 	esi					;

	push	1
	pop 	eax					; presupunem ca ipoteza e adevarata
	xor	edx, edx 				; contor pentru paranteze
for:
	cmp 	byte[esi+ecx-1], 41     		; compara daca este ')'
	je	plus					

	test 	edx, edx				; verificare daca '(' are pereche
	je      false					; secventa este gresita
	sub 	edx, 1					; s-a gasit o noua pereche
	loop 	for					
	jmp 	exit 					

plus:
	add	edx, 1					; se deschide un nou set de paranteze
	loop 	for					
	jmp     exit					

false:
	xor     eax, eax				; marcam cu 0 ipoteza falsa

exit:
	push    ebp
	pop 	esp
	pop	ebp
	ret
