%include "rw32-2022.inc"
section .data
section .text
;--- Úkol 3 ---
;
;Naprogramujte funkci "sort", která sestupně (od největšího k nejmenšímu) seřadí pole 16bitových prvků bez znaménka A.
;
;Ukázka algoritmu řazení v jazyce C:
;
;int *pA, i, j, N;
;for(i = 0; i < N; i++) {
;    for(j = i + 1; j < N; j++) {
;        if (pA[i] < pA[j]) { tmp = pA[i]; pA[i] = pA[j]; pA[j] = tmp; }      
;    }
; }
;
;void sort(unsigned short *pA, unsigned int N)
;  - vstup:
;    ESI: ukazatel na pole A (pole A obsahuje 16bitové hodnoty bez znaménka)
;    ECX: počet prvků pole A (32bitové číslo bez znaménka)
;  - funkce musí zachovat obsah všech registrů, kromě registru EAX a příznakového registru

sort:
    push ebp
    mov ebp, esp

    push ecx

    outer_loop:

        push ecx

        sub ecx, [ebp - 8]
        dec ecx

        inner_loop:

            push ebx
            mov ebx, 
            loop inner_loop 

        pop ecx
        loop outer_loop


    pop ecx
    pop ebp
    ret

CMAIN:
    push ebp
    mov ebp, esp



    pop ebp
    ret