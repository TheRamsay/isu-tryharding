%include "rw32-2022-mingw.inc"

section .data
	arr1 db 1,2,3,1,4,1,6,1
	N dd 8
    x db 1

section .text
; PASCAL convence
; L->R, uklizi fce
CMAIN:

    push arr1 ; ebp + 16
    push dword [N] ; ebp + 12
    push dword [x] ; ebp + 8

    call task22

	ret

task22:
    push ebp
    mov ebp, esp

    push ecx
    push ebx
    push edx
    xor ebx,ebx

    mov eax, [ebp+16] ; arr ptr
    mov ecx, [ebp+12] ; pocet prvku
    mov bl, [ebp+8] ; srovavany prvek
    mov edx, 0 ; pocitadlo

    looper:
    cmp [eax], bl
    je found
    inc eax
    loop looper
    looperend:
    mov eax, edx
    jmp end

    found:
    inc edx ; inkrementace poctu shod
    inc eax ; posun na dalsi prvek
    dec ecx ; dekrementace prvku pole
    cmp ecx, 0 ; kdybych byl na konci pole, nevracim se do loopu, ale na jeho konec
    je looperend
    jmp looper

    error:
    mov eax, -1

    end:
    pop edx
    pop ebx
    pop ecx
    pop ebp

    ret 3*4