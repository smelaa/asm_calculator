data1 segment
    nline   db 10,13, "$"
	welc	db "Wprowadz slowny opis dzialania: $"
    resmes	db "Wynikiem jest: $"

    zero    db 4, "zero$",     0
    one     db 5, "jeden$",    1
    two     db 3, "dwa$",      2
    three   db 4, "trzy$",     3
    four    db 6, "cztery$",   4
    five    db 4, "piec$",     5
    six     db 5, "szesc$",    6
    seven   db 6, "siedem$",   7
    eight   db 5, "osiem$",    8
    nine    db 8, "dziewiec$", 9

    ten         db 8d,  "dziesiec$",       10d
    eleven      db 10d, "jedenascie$",     11d
    twelve      db 9d,  "dwanascie$",      12d
    thirteen    db 10d, "trzynascie$",     13d
    fourteen    db 11d, "czternascie$",    14d
    fifteen     db 10d, "pietnascie$",     15d
    sixteen     db 10d, "szesnascie$",     16d
    seventenn   db 12d, "siedemnascie$",   17d
    eighteen    db 11d, "osiemnascie$",    18d
    nineteen    db 14d, "dziewietnascie$", 19d

    twenty  db 11d, "dwadziescia$",    20d
    thirty  db 11d, "trzydziesci$",    30d
    fourty  db 12d, "czterdziesci$",   40d
    fifty   db 12d, "piecdziesiat$",   50d
    sixty   db 13d, "szescdziesiat$",  60d
    seventy db 14d, "siedemdziesiat$", 70d
    eighty  db 13d, "osiemdziesiat$",  80d

    plus     db 4d, "plus$"
    minus    db 5d, "minus$"
    multiply db 4d, "razy$"

    err1    db "Blad danych wejsciowych!$"

    err2    db "Zla liczba argumentow$"

    buff1 db 50, ?, 55 dup("$") ;bufor na znaki wprowadzone przez uzytkownika

    ;arg db start, end, value
    arg1        db 0,0,0,"$"
    op          db 0,0,0
    arg2        db 0,0,0



data1 ends

;===============================================================================

code1 segment
start1:
	mov	    ax, seg stack1 ;ustawienie wskaznika stosu
	mov	    ss, ax 
	mov	    sp, offset stack1 

    mov     dx,offset welc ;wypisanie powitania
    call    print1

    mov     ax, seg data1 ;wczytanie danych do bufora
    mov     ds, ax
    mov     dx, offset buff1
    mov     ah, 0ah
    int     21h

    mov     ax, seg data1; znalezienie pierwszego arumentu
    mov     ds, ax
    mov     cl, byte ptr ds:[buff1+1] ;zapisanie rozmiaru bufora danych wpisanych przez użytkownika
    mov     ch, 1 ;zerowanie licznika do iteracji
    mov     bx, 2 ;ustawienie wskaznika na pierwszy znak w buforze

    get_arg1_start:
        mov     byte ptr ds:[arg1], 0
    
    find_arg1_end:
        mov     dh, byte ptr ds:[buff1+bx] ;zaladuj znak z bufora

        cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
        je      exception2 ;wyrzuc wyjatek

        cmp     dh, 32 ;porownaj czy znak jest spacja, 32-kod ASCII spacji
        je      get_arg1_end ;jesli tak to zapisz koniec argumentu

        inc     bx ;przesun wskaznik na kolejny znak
        inc     ch ;inkrementuj licznik
    jmp find_arg1_end

    get_arg1_end:
        dec     ch ;przesun ch na pierwszy znak przed spacja
        mov     byte ptr ds:[arg1+1], ch
        inc     ch

    ;get_op_start:
    inc     ch ;przejdz do pierwszego znaku po spacji
    inc     bx ;inkrementuj wskaźnik na kolejny znak
    mov     byte ptr ds:[op], ch

    find_op_end:
        mov     dh, byte ptr ds:[buff1+bx] ;zaladuj znak z bufora

        cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
        je      exception2 ;wyrzuc wyjatek

        cmp     dh, 32 ;porownaj czy znak jest spacja, 32-kod ASCII spacji
        je      get_op_end ;jesli tak to zapisz koniec argumentu
        
        inc     bx ;przesun wskaznik na kolejny znak
        inc     ch ;inkrementuj licznik petli
    jmp find_op_end

    get_op_end:
        cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
        je      exception2 ;wyrzuc wyjatek
        dec     ch ;przesun ch na pierwszy znak przed spacja
        mov     byte ptr ds:[op+1], ch
        inc     ch
    
    ;get_arg2_start:
    inc     ch ;przejdz do pierwszej pozycji argumentu po spacji
    inc     bx ;inkrementuj wskaźnik na kolejny znak
    cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
    je      exception2 ;wyrzuc wyjatek
    mov     byte ptr ds:[arg2], ch

    ;get_arg2_end:
    mov     byte ptr ds:[arg2+1], cl
    

    ;rozpoznaj pierwsza cyfre
    mov     di, offset zero
    call    compare_arg1

    mov     di, offset one
    call    compare_arg1

    mov     di, offset two
    call    compare_arg1

    mov     di, offset three
    call    compare_arg1

    mov     di, offset four
    call    compare_arg1

    mov     di, offset five
    call    compare_arg1

    mov     di, offset six
    call    compare_arg1

    mov     di, offset seven
    call    compare_arg1

    mov     di, offset eight
    call    compare_arg1

    mov     di, offset nine
    call    compare_arg1

    call    exception1 ;jezeli nie znaleziono dopasowania to wyrzuc blad
    end_comparing_arg1:
    

    call    printnline ;wypisanie tego co zostalo wczytane
    mov     dx, offset resmes
    call    print1
    mov     dx, offset buff1+2 
    call    print1

    end_prog:
        mov     al,0 ;koniec programu
        mov     ah,4ch
        int     21h

;============================================
;paramert dx - offset
    print1: 
        mov     ax, seg data1
        mov     ds, ax 
        mov     ah, 9h
        int     21h
        ret
;============================================
    printnline:
        mov     ax, seg data1
        mov     ds, ax 
        mov     dx,offset nline
        mov     ah, 9h
        int     21h
        ret
;============================================
    exception1:
        call    printnline
        mov     dx, offset err1
        call    print1
        jmp     end_prog 
;============================================
    exception2:
        call    printnline
        mov     dx, offset err2
        call    print1
        jmp     end_prog   
;============================================
;paramert di - offset na liczbę (one, two itd.)
    compare_arg1:
        mov     ax, seg data1
        mov     ds, ax

        mov     al, byte ptr ds:[arg1+1] ;do al arg_end
        mov     ah, byte ptr ds:[arg1] ;do ah arg_start
        sub     al, ah ;odejmnij i zdobadz dlugosc arg1 w al

        mov     ah, byte ptr ds:[di] ;do ah dlugosc parametru (na pierwszym bajcie mam zawsze dlugosci)

        cmp     al, ah ;jesli dlugosc tych slow sie rozni to skoncz porownanie
        jne     end_comp1

        mov     cl, al ;do cl zapisuje sobie dlugosc slowa

        inc     di ;di przesuwam na pierwszy znak parametru

        mov     bx, 2 ;ustawiam bx jako znacznik na pierwszy znak arg1 w buforze
        mov     bh, 0 
        add     bl, byte ptr ds:[arg1]

        mov     ch, 1 ;ustawiam licznik petli

        comp1:
            mov     dh, byte ptr ds:[buff1+bx] ;do dh wrzucam literke z arg1
            mov     dl, byte ptr ds:[di] ;do dl wrzucam literke z parametru

            cmp     dh, dl ;porownuje obie literki
            jne     end_comp1 ;jesli sa rozne to nie sprawdzam dalej

            cmp     ch, cl ;jesli dotarlam do konca petli to znalzlam argument
            je      is_found1

            inc bx ;zwiekszam wskazniki i liczniki petli
            inc di
            inc ch
        jmp comp1

        end_comp1:
            ret

        is_found1:
            inc     di
            inc     di ;ustaw di na wartosc liczby
            mov     al, byte ptr ds:[di]
            mov     byte ptr ds:[arg1+2], al ;ustaw wartosc argumentu
            jmp     end_comparing_arg1

code1 ends

;===============================================================================

stack1 segment stack
	dw	300 dup(?) 
wstack1	dw	?
stack1 ends

;===============================================================================

end start1