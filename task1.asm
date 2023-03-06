section .text
	global sort

struc node 
	.val:	resd 1
	.next:   resd 1   
endstruc

; struct node* sort(int n, struct node* node);
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list


sort:
	push    ebp
	mov 	ebp, esp
	
	mov 	ecx, dword [ebp + 8]   			; n
	mov	eax, dword [ebp + 12]			; node

	mov	edi, [eax + node.next]			; initializeaza cu NULL

for:
	mov	eax, dword [ebp + 12]			; incepe parcurgerea de la inceputul vectorului
	cmp 	dword [eax + node.val], ecx		; compara cu elementul cautat
	je	continue				; daca s-a gasit, continua la urmatorul element
find_elem:
	add 	eax, node_size				; trece la urmatoarea valoare
	cmp 	dword [eax + node.val], ecx		; compara cu elementul cautat
	jne	find_elem				; daca nu s-a gasit, continua cautarea

continue:
	mov	dword [eax + node.next], edi		; leaga nodul actual cu anscendentul
	mov	edi, eax				; salvare adresa nodului actual
	loop	for					

	leave
	ret
