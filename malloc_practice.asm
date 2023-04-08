%include "rw32-2022.inc"

section .data
	strPtr db "ahojda",0

section .text

;--- Úkol custom --- 

; Naprogramujte funkci 'replace', která zjistí, zda se v poli 32bitových hodnot, nalézá konkrétní hodnota. 

; Parametry funkce: 
;   strPtr = ukazatel na retezec
;   strLen = delka retezce
;   pattern = 32 bit unsigned integer ktery znaci vyhledavaci znak
;   replace_value = 32 bit unsigned integer ktery znaci novy znak
; 
; Priklad volani:
;   replace("ahoj", 'o', 'c') -> nam vrati "ahcj"

; Návratová hodnota: 
;   EAX = adresa nove allokovaneho stringu

; Důležité: 
;   - funkce musí zachovat obsah registrů, krome EAX a EFLAGS

replace:
    push ebp
    mov ebp, esp

    push esi
    mov esi, [ebp + 8] 

    push ebx
    push ecx
    push edx

    mov ecx, [ebp + 12]
    mov ebx, [ebp + 16] ; pattern
    mov edx, [ebp + 20] ; znak kterym se nahrazuje

    push edx
    push ecx
    call malloc 
    pop ecx
    pop edx

replace_loop:
    cmp [esi]< 0
    je replace_end

    cmp [esi], ebx
    jne skip:
    mov [esi], edx
skip:
    add esi, 1
    jmp replace_loop
replace_end:
    pop ebp
    ret

CMAIN:
    push ebp
    mov ebp, esp

    push 80 ; P
    push 97 ; a
    push 6
    push strPtr
    call replace
    add esp, 16

    call WriteString

    pop ebp
    ret