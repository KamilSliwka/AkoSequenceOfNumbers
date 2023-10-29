;Program wyœwietli na ekranie 50 pocz¹tkowych
;elementów ci¹gu liczb: 1, 2, 4, 7, 11, 16, 22, ... 
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
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
mov ebx, 10 ; dzielnik równy 10
konwersja:
mov edx, 0 ; zerowanie starszej czêœci dzielnej
div ebx ; dzielenie przez 10, reszta w EDX,
; iloraz w EAX
add dl, 30H ; zamiana reszty z dzielenia na kod
; ASCII
mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
dec esi ; zmniejszenie indeksu
cmp eax, 0 ; sprawdzenie czy iloraz = 0
jne konwersja ; skok, gdy iloraz niezerowy
; wype³nienie pozosta³ych bajtów spacjami i wpisanie
; znaków nowego wiersza
wypeln:
or esi, esi
jz wyswietl ; skok, gdy ESI = 0
mov byte PTR znaki [esi], 20H ; kod spacji
dec esi ; zmniejszenie indeksu
jmp wypeln
wyswietl:
mov byte PTR znaki [0], 0AH ; kod nowego wiersza
mov byte PTR znaki [11], 20H ; kod spacji
; wyœwietlenie cyfr na ekranie
push dword PTR 12 ; liczba wyœwietlanych znaków
push dword PTR OFFSET znaki ; adres wyœw. obszaru
push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
call __write ; wyœwietlenie liczby na ekranie
add esp, 12 ; usuniêcie parametrów ze stosu

popa
ret
wyswietl_EAX ENDP


_main:
; obszar instrukcji (rozkazów) programu
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

    ; zakoñczenie wykonywania programu
    push dword PTR 0 ; kod powrotu programu
    call _ExitProcess@4
END

