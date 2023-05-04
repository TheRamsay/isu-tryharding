%include "rw32-2022.inc"
section .data
    arr dd 1.12, 10.6, -20.312312, 5.5

section .text

; int cmp(void *a, void *b);
cmp:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 12]
    fld dword [eax] 

    mov eax, [ebp + 8]
    fld dword [eax]

    ; st(0) = a
    ; st(1) = b

    fcomip
    fstp st0

    ja gt
    jb lt
    mov eax, 0
cmp_end:
    pop ebp
    ret
gt:
    mov eax, 1
    jmp cmp_end
lt:
    mov eax, -1
    jmp cmp_end

task31:
    push ebp
    mov ebp, esp

    cmp esi, 0
    je null_ptr

    cmp ecx, 0
    je negative_count

    push cmp
    push 4
    push ecx
    push esi
    call qsort
    add esp, 16

    mov eax, 0
task31_end:
    pop ebp
    ret
negative_count: ; ECX < 0 
    mov eax, 2
    jmp task31_end
null_ptr: ; ESI == NULL
    cmp ecx, 0
    jge null_ptr_only
    mov eax, 3
    jmp task31_end
null_ptr_only: ; ESI == NULL && ECX >= 0
    mov eax, 1
    jmp task31_end

CMAIN:
	push ebp
	mov ebp,esp

    mov esi, arr
	mov ecx, 4
	call task31

	pop ebp
	ret


CEXTERN qsort