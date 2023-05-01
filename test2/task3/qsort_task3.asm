%include "rw32-2022.inc"

section .data
    arr dd 0, -20, 100, 4, -55
section .text

;--- Úkol 3 --- 
; 
; Naprogramujte funkci, která vzestupně (od nejmenšího k největšímu) seřadí 
; pole 32bitových prvků se znaménkem. Ukazatel no pole, které máte seřadit, 
; je v registru ESI, počet prvků je číslo se znaménkem a je v registru ECX. 
; Funkce task23 vrátí v EAX ukazatel na nové pole, které alokujete funkcí 
; 'malloc', a kam uložíte seřazené pole prvků. 
;
; Funkci 'malloc' importujte makrem CEXTERN: 
; 
;   CEXTERN malloc 
; Funkce 'malloc' je definována takto: 
;
;   void* malloc(size t N) 
;     * N je počet bytů, které mají být alokovány (32bitové číslo bez znaménka) 
;     * funkce vrací v EAX ukazatel (32bitové číslo bez znaménka) 
;     * funkce může změnit obsah registrů ECX a EDX 
;
; Vstup: 
;   * ESI = ukazatel na původní pole 32bitových čísel se znaménkem (nikdy nebude NULL = 0) 
;   * ECX = počet prvků pole (32bitové číslo se znaménkem, vždy větší než 0) 
;
; Výstup: 
;   * v EAX vrátíte ukazatel na pole 32bitových prvků se znaménkem 
;   seřazených vzestupně (od nejmenšího k největšímu) 

; Důležité: 
;   * Počítejte s tím, že ECX > 0 a ESI != NULL. 
;   * Funkce musí zachovat obsah všech registrů, kromě registru EAX a příznakového registru. 
;   * Funkce 'malloc' může změnit obsah registrů ECX a EDX => pokud je používáte, schovejte si je. 

; fn int compare(void * a, void *b)
compare:
    push ebp
    mov ebp, esp

    push ebx

    mov eax, [ebp + 8]
    mov eax, [eax]
    mov ebx, [ebp + 12]

    cmp eax, [ebx]
    jl lt 
    jg gt 
    mov eax, 0
    jmp end
lt:
    mov eax, -1
    jmp end
gt:
    mov eax, 1
end:
    pop ebx

    pop ebp
    ret

task23:
    push ebp
    mov ebp, esp

    push edx ; saving edx
    push ecx ; saving ecx
    push ecx ; pushed for malloc 

    push compare
    push 4
    push ecx
    push esi
    call qsort 
    add esp, 16

    ; multiplying ecx from line 61 by 4 (size of double word)
    shl dword [esp], 2
    call malloc 
    add esp, 4

    pop ecx
    pop edx
    
    push edi  
    push esi ; movsd modifies the content of ESI

    mov edi, eax
    rep movsd

    pop esi
    pop edi
    pop ebp
    ret

CMAIN:
    push ebp
    mov ebp, esp

    mov esi, arr
    mov ecx, 5
    call task23

    pop ebp
    ret


CEXTERN malloc
CEXTERN qsort 