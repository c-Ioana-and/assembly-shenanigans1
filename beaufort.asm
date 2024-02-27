%include "../include/io.mac"

section .data
    sum: db 0					; pentru retinerea literii criptate
    index: dd 0					; pentru pozitia curenta din plain
    indexkey: dd 0				; pentru pozitia curenta din cheie

section .text
    global beaufort
    extern printf

beaufort:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]					; len_plain
    mov ebx, [ebp + 12]					; plain(address of first element in string)
    mov ecx, [ebp + 16]					; len_key
    mov edx, [ebp + 20]					; key (address of first element in matrix)
    mov edi, [ebp + 24]					; tabula_recta
    mov esi, [ebp + 28]					; enc 

    ; nu voi folosi argumentul tabula_recta
    ; litera in urma criptarii va fi
    ; A + distanta dintre cele doua litere in alfabet (daca dist < 0)
    ; altfel Z + distanta

    push eax							; inserez in stiva lungimea
    push 0								; celor doua string-uri

    encrypt:
        pop dword[indexkey]				; preiau lungimea cheii
        push dword[indexkey]

        xor edi, edi

        mov dword[sum], 0				; aici se va afla diferenta dintre litere
        movzx edi, byte[ebx]
        add dword[sum], edi				; adaug litera din plain
        mov edi, dword[indexkey]		; retin pozitia din cheie
        movzx edi, byte[edx + edi]		; retin litera de la indexkey
        sub dword[sum], edi				; scad pt a afla diferenta dintre litere
        
        cmp dword[sum], 0
        jg other_way_around

        mov edi, "A"					; daca diferenta e negativa, litera noua va
        sub edi, dword[sum]				; rezulta din "A" + diferenta
        jmp encrypted
        
        other_way_around:				; daca distanta e pozitiva, litera noua va
            mov edi, "["				; rezulta din "Z" -  diferenta - 1
            sub edi, dword[sum]			; "Z" - 1 = "["

        encrypted:
            mov [esi], edi          	; introduc in enc litera
            pop edi                		; scot pozitia curenta din stiva si o cresc
            inc edi
            cmp edi, ecx				; daca am ajuns la finalul cheii, ma intorc
            je reinitialize       	 	; la inceputul ei
        
        reinit:

        pop dword[index]				; scot si pozitia curenta din plain
        dec dword[index]				; si o scad cu 1. daca e 0
        cmp dword[index], 0				; atunci nu mai exista litere de encriptat
        je done

        push dword[index]				; reinserez lungimile in stiva
        push edi						; pentru ca nu s-a terminat encriptarea
        add ebx, 1						; trec la urmatoarea litera din plain
        add esi, 1						; trec la urmatoarea pozitie din enc
    jmp encrypt
    
    reinitialize:
        mov edi, 0						; ma intorc la inceputul cheii
    jmp reinit


    done:
    popa
    leave
    ret