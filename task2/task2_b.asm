%include "rw32-2022.inc"

section .data
	arr1 db 1,2,3,4,5

section .text

;--- Úkol 2 --- ; 
; Naprogramujte funkci: int task22(const unsigned char *pA, int N, unsigned char x), která v poli 8bitových čísel bez znaménka pA 
; o délce N nalezne první výskyt hodnoty x a vrátí index hledané hodnoty. 
; Funkce dostává parametry, uklízí zásobník a vrací výsledek podle konvence PASCAL. 
; Parametry funkce: 
; 	pA: ukazatel na pole A 
;	N: počet prvků pole A 
;	x: hodnota, kterou hledáme 
; Návratová hodnota: 
; 	EAX = -1, pokud je pA neplatný ukazatel (pA == 0) nebo pokud N <= 0 nebo pokud hodnota x nebyla v poli nalezena 
; 	EAX = index hledané hodnoty (prvky pole jsou indexovány od 0) 
; Důležité: 
; 	- funkce MUSÍ zachovat obsah všech registrů, kromě registru EAX a příznakového registru. 

task22:
	push ebp
	mov ebp, esp

	push edi
	mov edi, [ebp + 16]

	push ecx
	mov ecx, [ebp + 12]

	; if (ptr == NULL) return -1
	cmp edi, 0
	je not_found

	; if (n <= 0) return -1
	cmp ecx, 0
	jle not_found

	mov al, [ebp + 8]

	repne scasb

	jne not_found

	sub [ebp + 12], ecx
	mov eax, [ebp + 12]
	dec eax
	jmp end
not_found:
	mov eax, -1
end:
	pop ecx
	pop edi
	pop ebp
	ret 12

CMAIN:
	push ebp
	mov ebp,esp

	push arr1
	push 5
	push 3
	call task22
	call WriteInt32

	pop ebp
	ret