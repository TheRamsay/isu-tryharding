%include "rw32-2022-mingw.inc"

section .data
    arr1 dd 1,2,3,4,5
    arr2 dd 1,2,0,4,5

section .text
CMAIN:
	push ebp
	mov ebp,esp
	
    call task21

	pop ebp
	ret

task21:
    mov esi, arr1
    mov edi, arr2
    mov ecx, 5

    repe cmpsd
    jne difference

    mov eax, 1
    jmp end

    difference:
    mov eax,0

    end:
    ret

