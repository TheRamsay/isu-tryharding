%include "rw32-2022.inc"

section .data

arr1 dt 1.0, -4.1, 1.1, -5.0
arr2 dd 0,0,0,0

pointer  dd 0.0

section .text

compare:
enter 0,0
    mov eax, [ebp+8]
    fld dword [eax]
    mov eax, [ebp+12]
    fld dword [eax]

    FCOMI
    jb bellow
    ja above
    jz equals


bellow:
    mov eax, -1
    leave
    ret
above:
    mov eax, 1
    leave
    ret
equals:
    mov eax, 0
    leave
    ret

;Alloactes new array of size n and returns pointer to it
allocate:
    CEXTERN malloc

    enter 0,0
    mov eax, [ebp+8] ; size of array
    push eax

    call malloc

    add esp, 4
    leave
    ret



;sorts array of size n and copies it to newly allocated array
sort_array:
    enter 0,0
    mov eax, [ebp+8] ; pointer to first array
    mov ebx, [ebp+12] ; pointer to new array
    mov ecx, [ebp+16] ; size N
    mov edi, ebx

looperos:
    ; fstp dword []
    ; mov  [pointer], st0
    ; mov eax, [pointer]

    fld tword [eax]
    add eax, 10
    fstp dword [ebx]
    add ebx, 4

loop looperos

sort:
CEXTERN qsort

push ebx
push 4
push 4
push compare
call qsort



leave
ret

;cdecl float * getSorted(const long double *pArr, unsigned int N)

CMAIN:

push 4
push arr2
push arr1
call sort_array

ret