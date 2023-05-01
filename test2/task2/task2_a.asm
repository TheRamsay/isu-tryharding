%include "rw32-2022.inc"

section .data
    arr1 dd -1110, -11110, -100000, -100, -40

section .text

;--- Úkol 2 --- ; 
; Naprogramujte funkci: int task22(const int *pA, int N), která v poli 32bitových čísel se znaménkem pA 
; nalezne maximum a vrátí jeho hodnotu v registru EAX. Délka pole je dána parametrem N. 
; Funkce dostává parametry, uklízí zásobník a vrací výsledek podle konvence PASCAL. 
;
; Parametry funkce: 
;   pA: ukazatel na začátek pole 32bitových prvků se znaménkem 
;   N: počet prvků pole pA (32bitové číslo se znaménkem) 

; Návratová hodnota: 
;   EAX = 0x80000000, když je pA neplatný ukazatel (pA == 0) nebo N <= 0 
;   EAX = hodnota 32bitového maxima se znaménkem. 

; Důležité: Funkce musí zachovat obsah všech registrů, kromě registru EAX a příznakového registru. 

task22:
    push ebp
    mov ebp, esp

    push esi
    push ecx

    mov esi, [ebp + 12] ; adresa pole
    mov ecx, [ebp + 8] ; N prvku

    ; nejmensi mozne cislo 1000_0000_0000_0000_0000_0000_0000_0000b
    mov eax, 0x80000000 

    ; if (pA == NULL) return
    cmp esi, 0 
    je end

    ; if (N <= 0) return
    cmp ecx, 0
    jle end

task_loop:
    ; if (max >= current_item) { skip } else { max = current_item }
    cmp eax, [esi]
    jge skip
    mov eax, [esi]
skip:
    ; current_item_ptr += sizeof(int) 
    add esi, 4
    loop task_loop
end:
    pop ecx
    pop esi
	pop ebp

    ; pascal cleanup
	ret 12

CMAIN:
	push ebp
	mov ebp,esp

    push arr1
    push 5
    call task22

    call WriteInt32

	pop ebp
	ret
