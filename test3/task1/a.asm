%include "rw32-2022.inc"
section .data
	arr1 dd 4.0, 2.0, 4.0, 8.0
    error_value dd 0

section .text

;
; ----- Task 1 ------
; Create a function: float task31(const float *array, long N, float (*f)(float), long *error) using the 
; CDECL calling convention to calculate the quadratic mean of the 'N' elements of an 'array' of the floats 
; transformed by the function 'f'. In case of any failure set the 'error' value if possible.
;
;                  N-1
; RMS = sqrt (1/N * Σ (a[i]*a[i]) ) = sqrt((1/N)*(a[0]*a[0] sqrt((1/N)*(a[0]*a[0] + a[1]*a[1] + ... +a[N-1]*a[N-1]))
;                  i=0
; Algorithm:
;   1) check conditions, calculate error code if no errors occured continue,
;      otherwise set error code, if possible, and return +QNaN
;   2) set acc = 0
;   3) for i = 0..N-1: acc += f(array[i])*f(array[i]), if f(array[i]) returns NaN => set *error-8 and return +QNaN 
;   4) set *error=0 and return sqrt(acc/N)
;
; Function parameters:
;   array = pointer to the array of floats
;   N = count of the elements in the array (long, 32bit signed integer)
;   f = pointer to a function (C language calling convention CDECL) calculating value of f(x), 
;       where x is a float and the function returns a float or QNaN in case f(x) is not defined for the given x 
;   error = pointer to a long value, if valid, you will store the error code there
;
; Return values:
;   * quadratic mean of the transformed array in case nothing has gone wrong *+QNaN in case of any error
;   * +QNaN in case of any error
;   * if (error != NULL) then
;       *error = 0, if there was no error
;       *error = 1, if ( N <= 0)
;       *error = 2, if (array == 0)
;       *error = 3, if (array == 0 && N <= 0)
;       *error = 4, if (f == 0)
;       *error = 5, if (f == 0 && N <= 0)
;       *error = 6, if (array == 0 && f == 0)
;       *error = 7, if (array == 0 && f == 0 && N <= 0)
;       *error = 8, if the function f(x) returned NaN for some x
; Important:
;   * you can use the logical OR to set multiple choices of the error code 
;   * in the CDECL calling convention:
;       * the called function expects a clean FPU stack and can erase it
;       * the called function cleans the FPU before returning back (except for the sto if it returns a float/double)
;       * the called function may change EAX, ECX and EDX without keeping its original value

Q_NaN EQU 0x7FC00001

; Jen pro testovaci ucely, v testu tuhle funkce nepiseme
nan_fn:
    finit 
    push dword Q_NaN
    fld dword [esp]
    add esp, 4

    ret

; Jen pro testovaci ucely, v testu tuhle funkce nepiseme
my_fn:
    push ebp
    mov ebp,esp

    finit 
    fld dword [ebp+8]

    pop ebp
    ret

task31:
    push ebp
    mov ebp,esp 

    sub esp, 4

    push esi

    mov esi, [ebp + 8] ; array
    mov ecx, [ebp + 12] ; N
    mov edx, [ebp + 16] ; f
    mov eax, [ebp + 20] ; errorPtr

    ; if (error == NULL) return
    cmp dword eax, 0
    je .end

    mov dword [eax], 0

    cmp esi, 0
    jne .arr_ok
    add dword [eax], 2
    .arr_ok:
    cmp ecx, 0
    jg .size_ok
    add dword [eax], 1
    .size_ok:
    cmp edx, 0
    jne .fn_ok
    add dword [eax], 4
    .fn_ok:
    cmp dword [eax], 0
    je .all_correct
    push dword Q_NaN; +QNaN
    fld dword [esp]
    add esp, 4
    jmp .end
    .all_correct:

    fldz ; acc = 0
.for:
    push eax
    push ecx
    push edx
    fst dword [ebp - 4] ; save st0 to local variable

    push dword [esi] ; push *currentElement 
    call edx ; call f(*currentElement)
    add esp, 4 ; CDECL cleanup

    pop edx
    pop ecx
    pop eax

    ; compare result of f() with itself, to check if it is NaN. Compare has to be unordered, to not cause an exception
    fucomi st0
    jp .nan_err ; if parity flag is set, then it is NaN

    fmul st0, st0 ; st1 = f(array[i]) * f(array[i])
    fld dword [ebp - 4] ; restor st0 from local variable
    faddp ; st0 = acc + f(array[i]) * f(array[i])
    add esi, 4 ; arrayPtr += sizeof(long)
    loop .for

    fld1 
    fild dword [ebp + 12] ; N
    fdivp st1, st0 ; st0 = 1/N

    fmulp ; st0 = 1/N * acc

    fsqrt ; st0 = sqrt(1/N * acc)
.end:
    add esp, 4 ; cleanup local variables
    pop esi
    pop ebp
    ret
.nan_err:
    mov dword [eax], 8
    jmp .end

CMAIN:
	push ebp
	mov ebp,esp

    ; push error_value
    ; push nan_fn
    ; push 4
    ; push arr1
    ; call task31
    ; add esp, 16

    push error_value
    push nan_fn
    push 4
    push arr1
    call task31
    add esp, 16

	pop ebp
	ret
