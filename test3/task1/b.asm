%include "rw32-2022.inc"
section .data
    str1 db "00000000000000000000000000000011",0
    str2 db "69420",0

section .text

task31:
    push ebp
    mov ebp, esp

    push ecx
    push edx

    push ebx ; base
    push 0   ; NULL ptr for endptr (we dont need it)
    push esi ; string 
    call strtoul
    add esp, 12

task31_end:
    pop ebx
    pop ecx
    pop ebp
    ret

CMAIN:
	push ebp
	mov ebp,esp

    mov ebx, 2
    mov esi, str1
    call task31

    call WriteInt32
    call WriteNewLine

    mov ebx, 10
    mov esi, str2
    call task31

    call WriteInt32
    call WriteNewLine

	pop ebp
	ret


CEXTERN strtoul