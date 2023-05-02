%include "rw32-2022.inc"

section .data
   
arr1 dd 1.0, 5.5, -4.75, 10.0
size dd 4
res1		DD -1.0

section .text

average:
    enter 0,0

    mov ecx, [ebp+8] ;size
    mov eax, [ebp+12]   ;arr1        ;st0    st1     st2     st3     st4
        
    FLD dword [eax + ecx*4 - 4]      ;10.0
    sub ecx,1

looperos:
    FLD dword [eax + ecx*4 - 4]      ;-4.7          10.0
    FADDP                            ;5.3

    loop looperos

    FILD dword [ebp+8]               ;4             
    FDIVP                             ;

    FSTP dword [res1]                 ;

    exit

CMAIN:

    ;                     ;st0    st1     st2     st3     st4
    ; FILD dword [a]      ;5
    ; FILD dword [c]      ;3     5
    ; FADD st0, st1       ;8     5

    ; FILD dword [b]      ;10     8        5
    ; FADD st0, st2       ;15     8         5

    ; FILD dword [c]      ;3      15        8         5
    ; FMUL st0, st3       ;15     15        8         5

    ; FILD dword [cnst]   ;10     15       15       8         5
    ; FSUBP               ;5      15       8         5

    ; FILD dword [b]      ;10     5       15       8         5

    ; FDIVP               ;0.5    15       8         5

    ; FSUB st2, st0       ;0.5    15      7.5     5
    ; FADD st0, st3


    push arr1
    push dword [size]
    call average
    

ret