%include "rw32-2022.inc"
section .data
    arr dd 1.0, 2.0, 3.0, 4.0, 5.0, 6.0

section .text

QNaN EQU 0x7FC00001
NEG_QNaN EQU 0xFFC00001

;--- Úkol 1 ---
;
; Naprogramujte funkci: float task31(const float *array, long N) s konvencí CDECL, která vrátí medián
; z prvků pole hodnot typu float.
;
; Algoritmus:
;   1) Vytvořte kopii původního pole (newArray)
;   2) Seřaďte nové pole podle velikosti (newArray)
;   3) Vraťte hodnotu ze středu seřazeného pole (newArray):
;        a) pokud je 'N' liché, vraťte hodnotu newArray[(N-1)/2]
;        b) pokud je 'N' sudé, vraťte hodnotu (newArray[N/2] + newArray[N/2 - 1])/2
;
; Parametry funkce:
;   array = ukazatel na pole hodnot typu float
;   N = počet prvků v poli (32bitové znaménkové číslo)
;
; Návratové hodnoty:
;   * -QNaN, pokud je array == NULL nebo N <= 0
;   * medián prvků pole array v ostatních případech
;
; Důležité:
;   * předpokládejte, že 'malloc' nikdy neselže
;   * konvence volání jazyka C
;       * vyžaduje, aby se funkce volaly s prázdným FPU, funkce může FPU vymazat
;       * vyžaduje, aby funkce před návratem vyprázdnila FPU (kromě st0 pokud vrací float/double)
;       * umožňuje měnit registry EAX, ECX a EDX bez jejich předchozího uložení
;   * ve funkcích NEsmíte použít instrukce FINIT, FNINIT, FCLEX, FNCLEX, FFREE, FINCSTP, FDECSTP,
;     FLDCW, FLDENV, FRSTOR, FXRSTOR.
;
; K vyřešení tohoto úkolu můžete použít funkce: 'malloc', 'memcpy', 'qsort' a 'free' ze standardní
; knihovny jazyka C (konvence CDECL). Tyto funkce jsou definovány následovně:
;
;   void* malloc( size_t size )
;
;       Allokuje 'size' bytů neinicializovaného prostoru. Pokud je alokace úspěšná, vrací ukazatel.
;
;   void free( void* ptr )
;
;       Dealokuje prostor dříve alokovaný funkcí 'malloc', na který ukazuje ukazatel 'ptr'.
;
;   void* memcpy( void *dest, const void *src, size_t count )
;
;       Kopíruje 'count' bytů z místa, na které ukazuje 'src', do místa, na které ukazuje 'dest'.
;       Obě místa v paměti jsou interpretována jako pole bytů. Vrací ukazatel 'dest'.
;
;   void qsort( void *ptr, size_t count, size_t size, int (*comp)(const void *, const void *) )
;
;       Seřadí pole prvků na adrese 'ptr', které má 'count' prvků, každý o velikosti 'size' bytů,
;       a která k porovnání hodnot využije funkci 'comp', jejíž ukazatel je předán jako poslední
;       parametr. Funkce 'comp' porovnává dva prvky pole a musíte ji naprogramovat.
;       Deklarována je takto:
;
;       int comp(const void *ptrA, const void *ptrB).
;
;           Funkce 'comp' (konvence CDECL) porovná prvek na adrese 'ptrA' s prvkem na adrese 'ptrB'
;           a vrátí jako výsledek celé číslo se znaménkem takto:
;
;           x < 0 (jakákoliv záporná hodnota) <=> *ptrA leží před *ptrB,
;           x = 0 <=> *ptrA == *ptrB,
;           x > 0 (jakákoliv kladná hodnota) <=> *ptrA leží za *ptrB,
;
;           kde 'x' je libovolná hodnota (typicky x = 1).
;

cmp:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 12]
    fld dword [eax]

    mov eax, [ebp + 8]
    fld dword [eax]

    fcomip
    fstp st0

    je .eq
    ja .gt
    mov eax , -1
.end:
    pop ebp
    ret
.eq:
    mov eax, 0
    jmp .end
.gt:
    mov eax, 1
    jmp .end

; Jen pro testovaci ucely, v testu tuhle funkce nepiseme
task31:
    push ebp
    mov ebp,esp 

    push esi
    push edi
    push ecx

    mov esi, [ebp + 8]; array
    mov ecx, [ebp + 12] ; array size

    cmp esi, 0
    je .err

    cmp ecx, 0
    jle .err

    push ecx
    push edx
    shl ecx, 2

    push ecx
    call malloc
    add esp, 4

    mov edi, eax

    pop edx
    pop ecx

    push ecx
    push edx

    shl ecx, 2

    push ecx
    push esi
    push edi
    call memcpy
    add esp, 12

    pop edx
    pop ecx

    push edx
    push ecx

    push cmp
    push 4
    push ecx
    push edi
    call qsort
    add esp, 16

    pop ecx
    pop edx

    test ecx, 1 ; if LSB is 1 then number is odd
    jnz .odd
    shr ecx, 1
    fld dword [edi + ecx * 4] 
    fld dword [edi + ecx * 4 - 4]
    faddp 
    push dword __float32__(2.0)
    fld dword [esp]
    add esp, 4
    fdivp ; arr[N/2] + arr[N/2 - 1] / 2

.end:
    pop ecx
    pop edi
    pop esi
    pop ebp
    ret
.odd:
    sub ecx, 1
    shr ecx, 1
    fld dword [edi + ecx * 4]
    jmp .end
.err:
    push NEG_QNaN
    fld dword [esp]
    add esp, 4
    jmp .end

CMAIN:
	push ebp
	mov ebp,esp

    push 6
    push arr
    call task31
    add esp, 8

	pop ebp
	ret

CEXTERN qsort
CEXTERN malloc
CEXTERN memcpy