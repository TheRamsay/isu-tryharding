%include "rw32-2022.inc"
section .data

section .text

QNaN EQU 0x7FC00001
NEG_QNaN EQU 0xFFC00001

task31:
    push ebp
    mov ebp,esp 

    push ecx

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
    fdivrp ; st0 = x/n 
    sub esp, 4 ; reserve space x0 variable
    fstp dword [ebp - 4] ; clean the fpu and save x0 to stack
.while:
    fild dword [ebp+8] ; n
    fld1
    fsubp ; st0 = n - 1
    fld dword [ebp - 4] ; x0
    fmulp ; st0 = x0 * (n - 1)

    fld dword [ebp+12] ; x
    fld dword [ebp - 4] ; x0

    ; st0 = x0  st1 = x st2 = x0 * (n - 1)

    push ecx ; saving ecx
    sub ecx, 1 ; ecx = n - 1
    .pow:
        cmp ecx, 1
        je .end_pow 
        fmul st0, st0 ; st0 = x0^2
        dec ecx
        jmp .pow

    .end_pow:
    pop ecx ; restore 

    fdivp ; st1 = x / x0^(n - 1)
    faddp ; st0 = x0 * (n - 1) + x / x0^(n - 1)
    fild dword [ebp+8] ; n
    fdivp ; st0 = (x0 * (n - 1) + x / x0^(n - 1)) / n
    ; st0 = x1

    fld st0 ; st0 = x1  st1 = x1
    fld dword [ebp - 4] ; st0 = x0  st1 = x1 st2 = x1
    fsubp ; st0 = x1 - x0  st1 = x1
    fabs ; st0 = |x1 - x0|  st1 = x1

    fld dword [ebp - 4] ; st0 = x0  st1 = |x1 - x0|  st2 = x1
    fld dword [ebp + 16] ; st0 = p st1 = x0  st2 = |x1 - x0|  st3 = x1
    fmulp ; st0 = p * x0  st1 = |x1 - x0|  st2 = x1
    fabs ; st0 = |p * x0|  st1 = |x1 - x0|  st2 = x1

    fcomip ; st0 = |x1 - x0|  st1 = x1
    fstp st0 ; st0 = x1
    ja .finished ; |p * x0| > |x1 - x0|  =>  x1 is the result
    fstp dword [ebp - 4] ; x0 = x1
    jmp .while
.finished:
    add esp, 4 ; free space for x0
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

    push  __float32__(0.1)
    push  __float32__(2.0)
    push 3
    call task31
    add esp, 12

	pop ebp
	ret
