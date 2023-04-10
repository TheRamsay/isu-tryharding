%include "rw32-2022.inc"

; Funkce multiply bere dve 8b cisla se znamenkem a vynasobi je
; Konvence volani je pascal
; V mainu pak vytiskneme rovnici `%d * %d = %d` s hodnotama z vypoctu pomoci printf

section .data
    sfmt db "%d * %d = %d ",10,0

section .text

multiply:
    push ebp
    mov ebp, esp

    mov al, [ebp + 8]
    ; AX = AL * [ebp + 12]  
    imul byte [ebp + 12]

    ; znamenkove rozsireni AX do EAX
    cwde
    ; alternativa - movsx eax, word ax

    pop ebp
    ; pascal convention
    ret 8

CMAIN:
    push ebp
    mov ebp, esp

    mov ecx, -31  ; a
    mov ebx, 100; b

    push ebx
    push ecx
    call multiply

    push eax ; vysledek z multiply
    push ebx ; b 
    push ecx ; a
    push sfmt
    call printf

    add esp, 4
    pop ecx
    pop ebx 
    add esp, 4

    pop ebp
    ret

CEXTERN printf