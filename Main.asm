;Program wy�wietli na ekranie 50 pocz�tkowych
;element�w ci�gu liczb: 1, 2, 4, 7, 11, 16, 22, ... 
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main


.data
; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
znaki db 12 dup (?)
tekst db 10,"Kolejne liczby ciagu to:",0 ,10
koniec db ?
.code

wyswietl_EAX PROC;konwersja na liczbe w postaci dziesietnej i wyswietlenie jej
pusha

mov esi, 10 ; indeks w tablicy 'znaki'
mov ebx, 10 ; dzielnik r�wny 10
konwersja:
mov edx, 0 ; zerowanie starszej cz�ci dzielnej
div ebx ; dzielenie przez 10, reszta w EDX,
; iloraz w EAX
add dl, 30H ; zamiana reszty z dzielenia na kod
; ASCII
mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
dec esi ; zmniejszenie indeksu
cmp eax, 0 ; sprawdzenie czy iloraz = 0
jne konwersja ; skok, gdy iloraz niezerowy
; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
; znak�w nowego wiersza
wypeln:
or esi, esi
jz wyswietl ; skok, gdy ESI = 0
mov byte PTR znaki [esi], 20H ; kod spacji
dec esi ; zmniejszenie indeksu
jmp wypeln
wyswietl:
mov byte PTR znaki [0], 0AH ; kod nowego wiersza
mov byte PTR znaki [11], 20H ; kod spacji
; wy�wietlenie cyfr na ekranie
push dword PTR 12 ; liczba wy�wietlanych znak�w
push dword PTR OFFSET znaki ; adres wy�w. obszaru
push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
call __write ; wy�wietlenie liczby na ekranie
add esp, 12 ; usuni�cie parametr�w ze stosu

popa
ret
wyswietl_EAX ENDP


_main:
; obszar instrukcji (rozkaz�w) programu
.code
    push (offset koniec) - (offset tekst)
    push offset tekst
    push 1
    call __write
    add esp,12
    
    mov eax,1
    mov ebx,1
    mov ecx,50 ;ile liczb ciagu nalezy wyswietlic
    ptl:
    call wyswietl_EAX
    add eax,ebx
    inc ebx
    dec ecx
    jnz ptl

    ; zako�czenie wykonywania programu
    push dword PTR 0 ; kod powrotu programu
    call _ExitProcess@4
END

