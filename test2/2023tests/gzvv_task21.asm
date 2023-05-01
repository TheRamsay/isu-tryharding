%include "rw32-2022.inc"

section .data
    task21_A dd 515498233,1400868278,2311446600,2491961727,1648177410,2954191230,3010743115,3243110902
    task21_B dd 515498233,1400868278,2311446600,2491961727,1648177410,2954191230,3010743115,3243110902
    ;task21_B dd 1666664157,3914895269,2858839048,664932826,3057619703,1751651968,457676272,1341126908


;
;--- Task 1 ---
;
; Create a function 'task21' to compare elements of two arrays of the 32bit unsigned values.
; Pointer to the first array is in the register EAX, pointer to the second array is in the register EBX,
; and count of the elements of both arrays is in the register ECX.
;
; Function parameters:
;   EAX = pointer to the first array of the 32bit unsigned values (EAX is always a valid pointer)
;   EBX = pointer to the second array of the 32bit unsigned values (EBX is always a valid pointer)
;   ECX = count of the elements of the arrays (ECX is an unsigned 32bit value, always greater than 0)
;
; Return values:
;   EAX = 1, if the arrays contain the same values, otherwise EAX = 0
;
; Important:
;   - the function does not have to preserve content of any register
;

section .text
CMAIN:
    push ebp
    mov ebp,esp

    mov eax,task21_A
    mov ebx,task21_B
    mov ecx,8
    call task21
    call WriteInt32

    pop ebp
    ret
    
    
task21:
    push ebp
    mov ebp, esp
    mov esi, 0
    
while:
    mov edx, [eax+4*esi]
    cmp edx, [ebx+4*esi]
    jne no
    add esi, 1
    loop while

    mov eax, 1
    jmp exit
no:
    mov eax, 0
exit:
    mov esp, ebp
    pop ebp
    ret