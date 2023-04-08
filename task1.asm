%include "rw32-2022.inc"

section .data
	arr1 dd 1,2,3,4,5

section .text

;--- Úkol 1 --- 

; Naprogramujte funkci 'task21', která zjistí, zda se v poli 32bitových hodnot, nalézá konkrétní hodnota. 
; Ukazatel na pole je v registru EAX, hledaná hodnota je v registru EBX a počet prvků pole je v registru ECX. 

; Parametry funkce: 
;   EAX = ukazatel na pole 32bitových hodnot, které má být prohledáno (EAX je vždy platný ukazatel) 
;   EBX = hledaná 32bitová hodnota 
;   ECX = počet prvků pole (32bitová hodnota bez znaménka, vždy větší než 0) 

; Návratová hodnota: 
;   EAX = 1, pokud se hodnota v poli vyskytuje, jinak EAX = O 

; Důležité: 
;   - funkce nemusí zachovat obsah registrů 

task21:
	mov esi, eax
	mov eax, 0
fn_loop:
	; hledany == prvek_pole ? 
	cmp ebx, [esi]
	; pokud ano tak skok
	je found
	; zvetseni adresy o 4 bajty -> posun na dalsi prvek
	add esi, 4
	loop fn_loop
konec:
	ret
found:
	mov eax, 1
	jmp konec

CMAIN:
	push ebp
	mov ebp,esp

	mov eax, arr1
	mov ebx, 3
	mov ecx, 5
	call task21
	call WriteInt32

	mov eax, arr1
	mov ebx, 12
	mov ecx, 5
	call task21
	call WriteInt32

	pop ebp
	ret