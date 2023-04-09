%include "rw32-2022.inc"
; REKURZIVNI VERZE
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

fib:
	push ebp
	mov ebp, esp

	push ebx ; temp var for results
	push edx ; n 
	push edi ; arr

	mov edx, [ebp + 8] ; n
	mov edi, [ebp + 12] ; arr

	; n == 0
	cmp edx, 0
	je n_is_zero

	; n == 1
	cmp edx, 1
	je n_is_one

	cmp word [edi + 2 * edx - 2 * 1], 0
	je true1
	else1:
		mov bx, [edi + 2 * edx - 2 * 1]
		mov [edi + 2 * edx], bx
		jmp endif1
	true1:
		push edi
		push edx
		sub word [esp], 1 ; N - 1
		call fib
		add esp, 8
		mov [edi + 2 * edx], ax
	endif1:

	cmp word [edi + 2 * edx - 2 * 2], 0
	je true2
	else2:
		mov bx, [edi + 2 * edx - 2 * 2]
		add [edi + 2 * edx], bx
		jmp endif2
	true2:
		push edi
		push edx
		sub word [esp], 2 ; N - 2
		call fib
		add esp, 8
		add [edi + 2 * edx], ax
	endif2:
fib_end:
	movzx eax, word [edi + 2 * edx]
	pop edi
	pop edx
	pop ebx
	pop ebp
	ret
n_is_zero:
	mov word [edi + 2*edx], 0
	mov eax, 0
	jmp fib_end
n_is_one:
	mov word [edi + 2*edx], 1
	mov eax, 1
	jmp fib_end

task23:
	; if (N <= 0) return 0
	cmp ecx, 0
	jle task_error

	; Zachovani prvku pole
	push ecx
	add ecx, 1
	; pocet prvku * sizeof(element)
	shl ecx, 1

	push edx
	push ecx
	call malloc
	add esp, 4
	pop edx

	; if (ptr == NULL) return 0
	cmp eax , 0
	je task_error

	pop ecx

	push eax
	push ecx
	call fib
	add esp, 4
	pop eax
task_end:
	ret
task_error:
	mov eax, 0
	jmp task_end

CMAIN:
	push ebp
	mov ebp,esp

	mov ecx, 7
	call task23
	add esp, 4

	pop ebp
	ret


CEXTERN malloc