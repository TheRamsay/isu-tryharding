%include "rw32-2022.inc"

section .data
    task23_A dw 46730,8500,48738,7095,34233,38834,3622,50031
    
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

section .text
CMAIN:
    push ebp
    mov ebp,esp

    mov ecx, 7
    call task23
    
    cmp eax, 0
    je .zero

    mov esi, 0
    mov ebx, eax
.loop:
    mov ax, [ebx+2*esi]

    call WriteInt16
    call WriteNewLine
    inc esi
    loop .loop

    mov eax, ebx
    jmp .end


.zero:
    call WriteInt32
    jmp .end

.end:

    pop ebp
    ret
 
task23:
    CEXTERN malloc
    	
    cmp ecx, 0
    jle task_error
    
    push ecx
    shl ecx, 1
    
    push ecx
    call malloc
    add esp, 4
    
    cmp eax, 0
    je task_error
    
    pop ecx
    push ecx
    
    mov dword [eax], 0
    
    cmp ecx, 1
    je task_end
    
    mov dword [eax + 2], 1
    
    sub ecx, 2
    
    push ebx
    mov ebx, 2

task_loop:
    mov dx, [eax + 2 * ebx - 2]
    mov [eax + 2 * ebx], dx

    mov dx, [eax + 2 * ebx - 4]
    add [eax + 2 * ebx], dx

    inc ebx
    loop task_loop
task_end:
    pop ebx
    pop ecx
    ret
task_error:
    mov eax, 0
    jmp task_end