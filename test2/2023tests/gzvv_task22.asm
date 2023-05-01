%include "rw32-2022.inc"

section .data
    task22_A dw 28460,7978,-6374,-6049,1505,-1367,4557,-4773
    task22_B dw -17080,-14223,-6500,9890,1822,26641,9945,27783

;
;--- Task 2 ---
;
; Create a function: void* task22(const short *pA, int N, short x) to search an array pA of N 16bit signed
; values for the first occurrence of the value x. The function returns pointer to the value in the array.
; The parameters are passed, the stack is cleaned and the result is returned according to the PASCAL calling convention.
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


section .text
CMAIN:
    push ebp
    mov ebp,esp


    ; store parameters according to the calling convention
    push task22_A
    push 8
    push word 1505
    call task22
    call WriteInt32

    pop ebp
    ret

task22:
	push ebp
	mov ebp, esp

	push edi
	mov edi, [ebp + 14]
	push ecx
	mov ecx, [ebp + 10]

	cmp edi, 0
	je .not_found
	cmp ecx, 0
	jle .not_found

        push edx
	mov dx, [ebp + 8]
        
        push esi
        mov esi, 0

        .loop:
        mov ax, [edi+2*esi]
        cmp ax, dx
        je .found
        add esi, 1
        loop .loop
.not_found:
	mov eax, 0
        jmp .end
.found:
        mov eax, esi
.end:
        pop esi
        pop edx
	pop ecx
	pop edi
	pop ebp
	ret 4+4+2