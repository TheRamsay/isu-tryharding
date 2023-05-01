%include "rw32-2022.inc"
; ITERATIVNI VERZE
section .data

section .text

;--- Úkol 3 --- ; 
; Naprogramujte funkci 'task23', která alokuje a naplní pole 16bitových celých čísel bez znaménka Fibonacciho čísly 
; F(0), F(1), , F(N-1). Požadovaný počet Fibonacciho čísel je uveden v registru ECX (32bitová hodnota se znaménkem) 
; a funkce vrací v EAX ukazatel na pole, které alokuje funkcí 'malloc' ze standardní knihovny jazyka C. 

; Fibonacciho čísla jsou definována takto: 
; 	F(0) = 
; 	F(1) = 1 
; 	F(n) = F(n-1) + F(n-2) 
;
; Vstup: 
;	 ECX = požadovaný počet prvků pole (32bitové celé číslo se znaménkem). 
;
; Výstup: 
; 	EAX = 0, pokud N <= 0, nic nealokujete a vrátíte hodnotu 0 (NULL), 
; 	EAX = 0, pokud došlo k chybě při alokování paměti funkcí 'malloc' (vrátí hodnotu 0), 
; 	EAX = ukazatel na pole 16bitových celočíselných prvků bez znaménka reprezentujících Fibonacciho čísla. 
;
; Důležité: 
; 	- funkce musí zachovat obsah všech registrů, kromě registru EAX a příznakového registru, 
; 	- funkce 'malloc' může změnit obsah registrů ECX a EDX. 

; Funkce 'malloc' je definována takto: 
; 	void* malloc(size_t N) N = počet bytů, které mají být alokovány (32bitové celé číslo bez znaménka), 
;	- funkce vrací v EAX ukazatel (32bitové celé číslo bez znaménka) na alokované místo v paměti, 
;	- funkce vrací v EAX hodnotu 0 (NULL) v případě chyby při alokování paměti, 
;	- funkce může změnit obsah registrů ECX a EDX. 

task23:
	; if (N <= 0) return 0
	cmp ecx, 0
	jle task_error

	; Zachovani prvku pole
	push ecx
	; pocet prvku * sizeof(element)
	shl ecx, 1

	push ecx
	call malloc
	add esp, 4

	; if (ptr == NULL) return 0
	cmp eax , 0
	je task_error

	; obnoveni ECX na puvodni hodnotu (to je pocet prvku) odpovida pushi na radku 40
	pop ecx
	; zachovani ECX znova, v loopu ho budeme zmensovat
	push ecx

	mov dword [eax], 0

	; N = 1, nema smysl pokracovat
	cmp ecx, 1
	je task_end

	mov dword [eax + 2], 1

	; minus prvni dva prvky
	sub ecx, 2

	; Pomocny counter na indexovani
	push ebx
	mov ebx, 2

task_loop:
	mov dx, [eax + 2 * ebx - 2]
	mov [eax + 2 * ebx], dx

	mov dx, [eax + 2 * ebx - 4]
	add [eax + 2 * ebx], dx

	inc ebx
	loop task_loop
task_end:
	pop ebx
	pop ecx
	ret
task_error:
	mov eax, 0
	jmp task_end

CMAIN:
	push ebp
	mov ebp,esp

	mov ecx, 5
	call task23

	pop ebp
	ret


CEXTERN malloc