%include "rw32-2022-mingw.inc"

section .data
	arr1 dw 7,-2,-7,4,-5,3,7,8
	x dw 7
	N dd 8

section .text

;CDECL
; R->L uklizi volajici
; SCAS porovnava registr A s polem EDI
CMAIN:

    push word [x]
    push dword [N]
    push arr1

    call task22
    ret 3*4


task22:
    push ebp
    mov ebp, esp

    push edi
    push ecx
    push edx

    mov edi, [ebp+8] ; array
    mov ax, [ebp+16] ; hledany
    mov ecx, [ebp+12] ; pocet

    looper:
    repne scasw
    je occurence

    jmp end

    occurence:
        mov edx, edi
        jmp looper

    end:
        mov eax, edi
    pop edx
    pop ecx
    pop edi
    pop ebp
    ret

