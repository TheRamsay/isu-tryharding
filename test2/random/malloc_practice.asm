%include "rw32-2022.inc"

section .data
	strPtr db "ahojda",0

section .text

;--- Úkol custom --- 

; Naprogramujte funkci 'replace', která nahradi kazdy vyskyt znaku `pattern` znakem `replace_value`

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
    push edi
    push ebx
    push ecx
    push edx

    cmp dword [ebp + 8], 0
    je replace_error

    cmp dword [ebp + 12], 0
    jl replace_error

    mov esi, [ebp + 8] ; string
    mov ecx, [ebp + 12] ; delka stringu
    mov bl, [ebp + 16] ; pattern
    mov dl, [ebp + 20] ; znak kterym se nahrazuje

    push edx

    push ecx
    add dword [esp], 1
    call malloc 

    mov edi, eax
    pop ecx
    pop edx

replace_loop:
    ; konec stringu
    cmp byte [esi], 0
    je replace_end_str

    cmp byte [esi], bl
    je replace_char
copy_char:
    movsb
    jmp continue
replace_char:
    mov byte [edi], dl
    add esi, 1
    add edi, 1
continue:
    jmp replace_loop
replace_end:
    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret
replace_end_str:
    ; string terminator
    mov byte [edi], 0
    jmp replace_end
replace_error:
    mov eax, 0
    jmp replace_end

CMAIN:
    push ebp
    mov ebp, esp

    push 80 ; P
    push 97 ; a
    push 6
    push strPtr
    call replace
    add esp, 16

    mov esi, eax
    call WriteString

    cmp eax, 0
    je skip

    push eax
    call free
    add esp, 4

skip:
    pop ebp
    ret

CEXTERN malloc
CEXTERN free