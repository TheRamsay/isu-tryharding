%include "rw32-2022-mingw.inc"

section .data
    arr1 dd 1,-8,7,-4,9,-2,3,6
    len dd 8

    ;PASCAL L->R a uklizi fce
	

section .text
CMAIN:

    push arr1
    push dword [len]
    call task22

	ret


task22:
    push ebp
    mov ebp, esp

    push ecx
    push ebx

    mov eax, [ebp + 12] ;pointer
    mov ebx, [eax + 0] ;prvni prvek bude minimum na zacatku
    mov ecx, [ebp + 8] ; pocet prvku

    looper:
    cmp [eax], ebx
    jg greater
    add eax, 4
    loop looper
    jmp end

    greater:
        mov ebx, [eax]
        add eax, 4
        dec ecx
        jmp looper

    end:
    mov eax, ebx

    pop ebx
    pop ecx
    pop ebp
    ret 8