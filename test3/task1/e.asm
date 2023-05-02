%include "rw32-2022.inc"
section .data

section .text

QNaN EQU 0x7FC00001
NEG_QNaN EQU 0xFFC00001

; Jen pro testovaci ucely, v testu tuhle funkce nepiseme
task31:
    push ebp
    mov ebp,esp 

    mov ecx, [ebp+8] ; N

    cmp ecx, 2
    jl .lt_2_err ; x < 2

    fldz
    fld dword [ebp+12] ; x
    fcomip
    jae .skip ; x >= 0
    test dword [ebp+12], 1
    jz .even_and_neg ; x is even and negative
.skip:

    fild dword [ebp+8] ; n
    fld dword [ebp+12] ; x
    fdivp
    sub esp, 4
    fst dword [ebp - 4]
.while:
    fild dword [ebp+8] ; n
    fld1
    fsubrp
    fmulp
    fld dword [ebp+12] ; x

    fld dword [ebp - 4]
    fild ecx
    

    loop while

.end:
    pop ecx
    pop ebp
    ret
.lt_2_err:
    push QNaN
    fld dword [esp]
    add esp, 4
    jmp .end
.even_and_neg:
    push NEG_QNaN
    fld dword [esp]
    add esp, 4
    jmp .end

CMAIN:
	push ebp
	mov ebp,esp

    push  
    push 
    push 10
    call task31
    add esp, 12

	pop ebp
	ret
