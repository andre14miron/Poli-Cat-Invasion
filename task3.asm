global get_words
global compare_func
global sort
extern qsort
extern strlen
extern strcmp

section .text

compare_func:
    	push    ebp
	mov 	ebp, esp

    	; calculare lungimea primului cuvant
    	mov     eax, dword [ebp + 8]    ; primul cuvant
    	mov     eax, dword [eax]        ; copiaza valoarea de la adresa cuvantului
    	push    eax                     ; punere pe stiva pentru apelarea functiei strlen
    	call    strlen                   
    	add     esp, 4                  
    	push    eax                     ; pune pe stiva prima lungime

    	; calculare lungimea celui de-al doilea cuvant
    	mov     eax, dword [ebp + 12]   ; al doilea cuvant
    	mov     eax, dword [eax]        ; copiaza valoarea de la adresa cuvantului
    	push    eax                     ; punere pe stiva pentru apelarea functiei strlen
    	call    strlen                  
    	add     esp, 4                  
    
    	pop     ecx                     ; scoatere de pe stiva a primei lungimi
    	sub     ecx, eax                ; diferenta dintre lungimi
    	jg      bigger                  ; daca prima lung. > a doua lung, at. se va returna 1 
    	jl      smaller                 ; daca prima lung. < a doua lung, at. se va returna 0

    	; pentru ca lungimile au fost egale, se va face comparatia lexicografica
    	mov     eax, dword [ebp + 12]   ; copiere al doilea cuvant
    	mov     edx, dword [eax]        ; copiaza valoarea de la adresa cuvantului
    	mov     eax, dword [ebp + 8]    ; copiere primul cuvant
    	mov     eax, dword [eax]        ; copiaza valoarea de la adresa cuvantului
    	push    edx                     ; pune pe stiva al doilea cuvant
    	push    eax                     ; pune pe stiva primul cuvant
    	call    strcmp                  
    	add     esp, 4                  
    	jmp     exitcmp                 
   
bigger:
    	mov     eax, 1                  ; se returneaza 1
    	jmp     exitcmp                 

smaller:
    	mov     eax, 0                  ; se returneaza 0

exitcmp:
    	leave
    	ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    	push    ebp
	mov 	ebp, esp

    	mov 	eax, dword [ebp + 8]   	; words
	mov     ecx, dword [ebp + 12]  	; number_of_words
    	mov     edx, dword [ebp + 16]  	; size

    	push    compare_func            ; pune pe stiva functia de comparare
    	push    edx                     ; pune pe stiva size-ul unui element
    	push    ecx                     ; pune pe stiva numarul de elemente
    	push    eax                     ; pune pe stiva words
    	call    qsort                   
    	add     esp, 16                 

    	leave
    	ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    	push    ebp
	mov 	ebp, esp

    	mov 	ecx, dword [ebp + 8]   	; s
	mov     edx, dword [ebp + 12]  	; words

    	mov     edi, 0                  ; lungimea cuvantului care se separa
    	xor     esi, esi                ; contor pentru words
    	xor     eax, eax                ; 0 = s-au gasit doar delimitatori, altfel 1

for:
    	cmp     esi, dword [ebp + 16]   ; verificare daca s-au separat toate cuvintele
    	je      exit                    ; daca da, s-a incheiat procesul de separare
  
    	cmp     byte[ecx + edi], 32     ; verificare daca litera curenta este spatiu
    	je      found                   ;
    	cmp     byte[ecx + edi], 46     ; verificare daca litera curenta este punct
    	je      found                   ;
    	cmp     byte[ecx + edi], 44     ; verificare daca litera curenta este virgula
    	je      found                   ;
    	cmp     byte[ecx + edi], 10     ; verificare daca litera curenta este '\n'
    	je      found

    	inc     edi                     ; se mareste lungimea cuvantului actual
    	mov     eax, 1                  ; cuvantul contine cel putin un caracter diferit de delimitatori
    	jmp     for 

found:
    	cmp     eax, 0                  ; verificare daca nu este formata doar din delimitatori
    	je      notword                 ; daca nu are caractere, atunci nu se copiaza in word
    
    	mov     eax, ecx                ; copiere adresa de inceput a cuvantului
    	mov     byte[eax + edi], 0      ; separa cuvantul de textul ramas
    	mov     [edx], eax              ; copiere in words
    
    	xor     eax, eax                ; initializare cu 0 pentru cautarea urmatorului cuvant
    	add     edx, 4                  ; mutare la urmatorul cuvant in words
    	inc     esi                     ; numarul de cuvinte gasite pana acum se mareste
    	add     ecx, edi                ; mutare la urmatoarea adresa de inceput a unui cuvant
    	add     ecx, 1                  ;
    	mov     edi, 0                  ; lungimea noului cuvant cautat este initializat cu 0
    	jmp     for

notword:
    	add ecx, 1                      ; adresa de inceput se muta cu un caracter
    	jmp for
    
exit:
    	mov     edx, dword [ebp + 12]   ; copiere adresa de inceput words
    	
	leave
    	ret
