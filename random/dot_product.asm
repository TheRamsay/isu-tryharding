%include "rw32-2022.inc"

section .data
    arr1 db 1,2,-4,8,-7
    arr2 db 10,4,3,-19,2

section .text

;--- Úkol custom --- 

; V datovém segmentu vytvořte dva vektory pěti 8b čísel. 
; Vytvořte funkci "skalsouc" která bude počítat skalární součin dvou vektorů:

; Parametry: 
;   ptrA odkaz na pole signed 8bit integeru
;   ptrB odkaz na pole signed 8bit integeru
;   delka obou poli (predpokladejte ze jsou stejne dlouha)

; Výstup: 
;   Výsledek skalárního součinu uložený v registru eax.
;   Funkce bude menit jen registr EAX a EFLAGS
;   konvence volaji je CDECL


skalsouc:
    push ebp
    mov ebp, esp

    push esi
    push edi
    push ecx
    push ebx

    mov esi, [ebp + 8] ; arr1
    mov edi, [ebp + 12] ; arr2
    mov ecx, [ebp + 16] ; length

    xor ebx, ebx
while:
    mov al, [esi]
    imul byte [edi]
    
    ; EAX = sign_extend(AX)
    cwde
    add ebx, eax

    inc esi
    inc edi

    loop while
end:
    mov eax, ebx

    pop ebx
    pop ecx
    pop edi
    pop esi
    pop ebp
    ret

CMAIN:
    push ebp
    mov ebp, esp

    push 2
    push arr2
    push arr1
    call skalsouc
    add esp, 12

    pop ebp
    ret