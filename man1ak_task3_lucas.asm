%include "rw32-2022-mingw.inc"

section .data
	

section .text
CMAIN:

    mov ecx, 10 ; provizorne si hodim do ecx nejaky cislo
    call task23

	ret

CEXTERN malloc ; extern pro malloc

task23:
    push ebp
    mov ebp, esp

    cmp ecx, 0 ; kontrola jestli N je vetsi nez nula
    jbe counterror ; kdyz neni skok na error

    push ecx ; schovani ecx
    shl ecx, 1 ; Je potreba vynasobit 10 * 2 bajty protoze mam 16bitovy cisla
    push ecx ; poslani argumentu pro malloc na zasobnik
    call malloc
    add esp, 4 ; odstraneni argumentu fce ze zasobniku
    pop ecx ; vraceni ecx do puvodniho stavu

    cmp eax, 0 ;kontroluju jestli malloc nevratil NULL
    je error ; jestli jo skok na chybu

    push ebx ; ebx bude pro docasny ukladani
    push edx ; edx bude indexer
    xor ebx, ebx ; pro jistotu nuluju registry
    xor edx, edx

    mov word [eax], 2    ;nultej prvek pole je 2
    mov word [eax+2], 1  ;prvni prvek pole je 1

    mov edx, 2 ; presunu pocet aktualnich prvku do indexeru
    

    push ecx ; schovam si znovu ecx na zasobnik, v loopu se bude menit
    sub ecx, 2 ; soucasny pocet prvku v poli je o dva prvky mene

    looper:
    mov bx, [eax + 2 * edx - 2] ; Vrazim do ebx L(n-1)
    mov [eax + 2 * edx], bx ; Nachystam si do pole L(n-1)

    mov bx, [eax + 2 * edx - 4] ; Vrazim si do ebx L(n-2)
    add [eax + 2*edx], bx ; Sectu v poli L(n-1) + L(n-2)

    inc edx ; prictu index
    loop looper ;loopuju dokud mam v poli misto
    jmp end ;po skonceni loopu skocit na konec, v EAX uz je ukazatel na vyplneny pole

; Chybny vstupy
    counterror:
    mov eax, 0
    jmp countend

    error:
    mov eax, 0

    end:
    pop ecx
    pop edx
    pop ebx
    countend: ;tenhle end je pro pripad ze hned na zacatku se to posralo a tim padem nemam do ecx, edx a ebx co popovat a skocim rovnou sem
    pop ebp
    ret
