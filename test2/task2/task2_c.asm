%include "rw32-2022.inc"

section .data
    arr1 dw 11, 11, 132, 0, 11

section .text

;--- Task 2 --- ; 
; Create a function: int task22(const unsigned short xpA, int N, unsigned short x) to count all occurrences of the values equal to x 
; in an array pA of N 16bit unsigned values. 
; The parameters are passed, the stack is cleaned and the result is returned according to the CDECL calling convention. 

; Function parameters: 
;   pA: pointer to the array A 
;   N: length of the array A 
;   x: comparison value 

; Return values: 
;   EAX = -1 if the pointer pA is invalid (pA == 0) or N < 0 
;   EAX = count of the elements of the array equal to x 

; Important: 
;   - the function MUST preserve content of all the registers except for the EAX and flags registers. 

task22:
    push ebp
    mov ebp, esp

    push esi
    push ecx
    push ebx

    mov eax, 0

    mov esi, [ebp + 8] ; adresa pole
    mov ecx, [ebp + 12] ; N prvku
    mov bx, [ebp + 16] ; wanted item

    ; if (pA == NULL) return
    cmp esi, 0
    je error

    ; if (N <= 0) return
    cmp ecx, 0
    jle error
task_loop:
    ; if (wanted != current_item) { skip } else { occurences++ }
    cmp bx, [esi]
    jne skip
    inc eax
skip:
    ; current_item_ptr += sizeof(int) 
    add esi, 2
    loop task_loop
end:
    pop ebx
    pop ecx
    pop esi
	pop ebp

	ret
error:
    mov eax, -1
    jmp end

CMAIN:
	push ebp
	mov ebp,esp

    push 1
    push 5
    push arr1
    call task22
    ;CDECL convention cleanup
    add esp, 12

    call WriteInt32

	pop ebp
	ret
