%include "rw32-2022.inc"

section .data
    task31_array dd 1.5,-100.0,30.0,-5.5,1.0,-1.0,200.0
    task31_array_len dd 7
    task31_error dd -1

section .text

task31_fn_example:
    finit
    fld dword [esp+4]
    xor ecx,-1
    xor edx,-1
    xor eax,-1
    ret

CMAIN:
    push ebp
    mov ebp,esp
    sub esp,4

    ; un-mask FPU exceptions, comment it if you do not want it
    fstcw [esp]
    and [esp],word 1111_1111_1110_0000b
    fldcw [esp]

    ; the function calls below should be correct,
    ; if you feel you need to modify it
    ; you might be doing something wrong
    
;    push task31_error
 ;   push task31_fn_example
  ;  push dword [task31_array_len]
   ; push task31_array
    ;call task31
    ;add esp,16
    
    push __float32__(17.350)
    push __float32__(22.350)
    call task32
    add esp,8


    mov esp,ebp
    pop ebp
    ret

;
;--- Task 2 ---
;
; Create a function: float task32(float x, float y) to evaluate a function f(x,y) for the given input (x, y)
; using FPU. The function returns the result of the evaluation in the ST0 FPU register. The function receives its
; parameters x and y on the stack in order from the last to the first, the stack is cleared by the caller and the
; result is returned in the ST0 FPU register (C calling convention - CDECL). 
;
; The function f(x,y) is defined as follows:
;
;
;            sqrt(y + 6.350) * cos(y + pi*x)
; f(x,y) = ---------------------------------------------
;                    abs(y + x/4)
;
;
; Function parameters:
;   x: IEEE754 single precision 32bit floating point number (float),
;   y: IEEE754 single precision 32bit floating point number (float),
;
; Return values:
;   ST0 = f(x,y), ignore exceptions caused by the division by zero or square root of a negative number
;
; Important:
;   - you are not allowed to use the following FPU instructions: FINIT, FNINIT, FCLEX, FNCLEX, FFREE, FINCSTP, FDECSTP,
;     FLDCW, FLDENV, FRSTOR, FXRSTOR,
;   - assume that the FPU has already been initialized by the FINIT instruction,
;   - the function MUST preserve content of all the registers except for the EAX, ECX, EDX and flags registers,
;   - the function MUST empty the FPU stack except for the ST0 register, in which the function returns its result.



task32:
    push ebp
    mov ebp, esp

    ;cdecl
    ;x = [ebp+8]
    ;y = [ebp+12]

    FLD dword [ebp+8]
    FLDPI
    FMULP

    FLD dword [ebp+12]
    FADDP

    FLDPI
    push dword 180
    FILD dword [esp]
    add esp, 4
    FDIVP

    FMULP
    FCOS

    push __float32__(6.35)
    
    FLD dword [esp]
    add esp, 4

    FLD dword [ebp+12]
    FADDP

    FSQRT
    FMULP

    push dword 4
    FILD dword [esp]
    add esp, 4

    FLD dword [ebp+8]
    FDIVP

    FLD dword [ebp+12]
    FADDP

    FABS

    FDIVP

    POP ebp
    ret