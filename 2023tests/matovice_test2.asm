%include "rw32-2022-mingw.inc"

section .data
    task21_A dd -236504705,104002607,-696264997,-126222963,1296377743,1354240916,-1787103719,1177757402
    task21_B dd 1958895341,1847265988,1374639895,-817349433,55278173,-2078285761,-1673751886,-1430701487
    arr1 dd 1,2,5,4,5,5
    task22_A dd 4220390780,2753148440,2157549578,3043327145,2658861317,616290113,592171405,1651681635
    task22_B dd 3388384984,803837448,3560314983,169429824,4089164061,2345899493,305549627,3744763853
    task23_A dw 61205,5026,63245,40757,8884,34373,49306,9943

section .text
CMAIN:
    push ebp
    mov ebp,esp

        mov eax,task21_A
    mov EBX,-80
    mov ecx,8
    call task21

    push 5
    push 6
    push arr1
    ; eax = task22(task22_A,8,27)
    ; store parameters according to the calling convention
    call task22
    ; process the result

        mov ecx,7
    call task23

    pop ebp
    ret
;
;--- Task 1 ---
;
; Create a function 'task21' to find if there is a value in an array of the 32bit signed values.
; Pointer to the array is in the register EAX, the value to be found is in the register EBX
; and the count of the elements of the array is in the register ECX.
;
; Function parameters:
;   EAX = pointer to the array of the 32bit signed values (EAX is always a valid pointer)
;   EBX = 32bit signed value to be found
;   ECX = count of the elements of the array (ECX is an unsigned 32bit value, always greater than 0)
;
; Return values:
;   EAX = 1, if the value has been found in the array, otherwise EAX = 0
;
; Important:
;   - the function does not have to preserve content of any register
;
task21:
looped:
    cmp ebx, [eax+ecx*4-4]
    je is_found
    loop looped
    mov eax,0
    jmp end
is_found:
    mov eax,1
end:
    ret

;
;--- Task 2 ---
;
; Create a function: void* task22(const unsigned int *pA, int N, unsigned int x) to search an array pA of N 32bit unsigned
; values for the last occurrence of the value x. The function returns pointer to the value in the array.
; The parameters are passed, the stack is cleaned and the result is returned according to the STDCALL calling convention.
;
; Function parameters:
;   pA: pointer to the array A to search in
;    N: length of the array A
;    x: value to be searched for
;
; Return values:
;   EAX = 0 if the pointer pA is invalid (pA == 0) or N <= 0 or the value x has not been found in the array
;   EAX = pointer to the value x in the array (the array elements are indexed from 0)
;
; Important:
;   - the function MUST preserve content of all the registers except for the EAX and flags registers.
;
task22:
    push ebp
    mov ebp,esp
    push ebx
    push ecx
    push edx
    push esi
    ;v ebp+8 bude hledana hodnota x, v ebp+12 bude delka arraye, v ebp+16 je pointer na array
    ;do ebx si dame 0 at muzeme indexovat array od zacatku,do eax dame 0 ktera se prepise jen pokud bude nalezen aspon jednou, do ecx dame hledane cislo, a do edx dame pointer na array
    mov ebx,0
    mov eax,0
    mov ecx,[ebp+16]
    mov edx,[ebp+8]
    ;zkontrolujeme jestli pointer je validni a jestli jeho length je vetsi nez 0
    cmp [ebp+12], ebx
    jle invalid
    cmp [ebp+8],ebx
    je invalid
comparison:
    cmp [ebx*4+edx],ecx
    je found
    cmp [ebp+12],ebx
    jne increment
    jmp konec
invalid:
    mov eax,0
    jmp konec
found:
    mov esi,ebx
    shl esi,2
    mov eax,edx
    add eax,esi
increment:
    inc ebx
    jmp comparison
konec:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret 12

;
;--- Task 3 ---
;
; Create a function 'task23' to allocate and fill an array of the 16bit unsigned elements by the
; Fibonacci numbers F(0), F(1), ... , F(N-1). Requested count of the Fibonacci numbers is
; in the register ECX (32bit signed integer) and the function returns a pointer to the array
; allocated using the 'malloc' function from the standard C library in the register EAX.
;
; Fibonacci numbers are defined as follows:
;
;   F(0) = 0
;   F(1) = 1
;   F(n) = F(n-1) + F(n-2)
;
; Function parameters:
;   ECX = requested count of the Fibonacci numbers (32bit signed integer).
;
; Return values:
;   EAX = 0, if ECX <= 0, do not allocate any memory and return value 0 (NULL),
;   EAX = 0, if memory allocation by the 'malloc' function fails ('malloc' returns 0),
;   EAX = pointer to the array of N 16bit unsigned integer elements of the Fibonacci sequence.
;
; Important:
;   - the function MUST preserve content of all the registers except for the EAX and flags registers,
;   - the 'malloc' function may change the content of the ECX and EDX registers.
;
; The 'malloc' function is defined as follows:
;
;   void* malloc(size_t N)
;     N: count of bytes to be allocated (32bit unsigned integer),
;     - in the EAX register it returns the pointer to the allocated memory,
;     - in the EAX register it returns 0 (NULL) in case of a memory allocation error,
;     - the function may change the content of the ECX and EDX registers.
;
task23:
    CEXTERN malloc
    cmp ecx,0
    jle error
    push ecx
    mov eax,2
    mul ecx
    push eax
    call malloc
    cmp eax,0
    je error
    add esp,4
    pop ecx
    mov esi,0
    mov [eax],word 0
    inc esi
    mov [eax+2],word 1
    inc esi
fibonacci:
    mov edi,[eax+esi*2-2]
    mov edx,[eax+esi*2-4]
    add edi,edx
    mov [eax+esi*2],edi
    inc esi
    cmp esi,ecx
    je end1
    jmp fibonacci


error:
    mov eax,0
    jmp end1
end1:
    ret

