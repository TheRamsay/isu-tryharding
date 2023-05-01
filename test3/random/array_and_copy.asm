%include "rw32-2022.inc"

section .data
   
arr1 dd 1.0, 5.5, -4.75, 10.0
arr2 dd -7.0, 15.5, -14.75, 2.3
size dd 4

section .text

;Calls malloc
allocate:
CEXTERN malloc
    enter 0,0

    mov ecx, [ebp+8] ;size

	; pocet prvku * sizeof(element)
	shl ecx, 2

	push ecx
	call malloc
	add esp, 4

    leave

    ret
add_and_copy:
    enter 0,0

    mov ecx, [ebp+8] ;size
    mov edx, [ebp+12] ;arr2
    mov ebx, [ebp+16] ;arr1
    mov eax, [ebp+20] ;new_array

looperos:
    FLD dword [ebx + ecx*4 - 4]  ; load first element of array 1
    FLD dword [edx + ecx*4 - 4]  ; load first element of array 2

    FADDP ;add the two elements

    FSTP dword [eax + ecx*4 - 4] ;store the result in the new array

    loop looperos


    leave

ret
CMAIN:

   

    push arr1
    push dword [size]
    call allocate
    add esp, 8

    push eax
    push arr2   
    push arr1
    push dword [size]
    call add_and_copy
    add esp , 16



ret