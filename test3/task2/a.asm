%include "rw32-2022.inc"
section .data
    arr dd 1.12, 10.6, -20.312312, 5.5

section .text


task32:
    push ebp
    mov ebp, esp

    fld dword [ebp + 12]
    push __float__32(6.35)
    fld dword [esp]
    add esp, 4
    fadd
    fsqrt
task32_end:
    pop ebp
    ret 8

CMAIN:
	push ebp
	mov ebp,esp

    push __float__32(10.0)
    push __float__32(4.0)
	call task31

	pop ebp
	ret