%include "../include/io.mac"

section .data
    lc: dd 0                    ; (retine cate elem am pe linie - 1 ) * 4
    newlc: dd 0                 ; variabila pentru parcurgerea unui "patrat"
    max: dd 0                   ; cate elemente voi folosi din col/linia cheii
    divided: dd 0               ; retine cate "patrate" exista in matrice
    poz: dd 0                   ; incrementez pentru fiecare patrat parcurs

section .text
    global spiral
    extern printf


spiral:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]          ; N (size of key line)
    mov ebx, [ebp + 12]         ; plain (address of first element in string)
    mov ecx, [ebp + 16]         ; key (address of first element in matrix)
    mov edx, [ebp + 20]         ; enc_string(address of first element in string)
    
    cmp eax, 1
    je not_even                 ; o matrice 1x1 va avea un "patrat"

    mov esi, 2
    div2:                       ; calculez cate patrate exista in matrice
        inc dword[divided]
        cmp esi, eax
        jge off_to_square       
        add esi, 2
    jmp div2                    ; formula : N / 2 (pare), N / 2 + 1 (impare)
    
    not_even:                   ; am doar 1 patrat in cazul N = 1
        inc dword[divided]

    ; Am considerat matricea un vector de N * N elemente continue

    off_to_square:              ; aici calculez distanta in memorie
        mov esi, eax            ; intre doua elemente de pe linii/col diferite
        mov dword[lc], 0
        square:
            cmp esi, 1          ; voi obtine practic pozitia elementului K[1,N]
            je spirala          ; in memorie
            add dword[lc], 4    ; distanta dinte doua elemente consecutive = 4
            sub esi, 1
        jmp square
    
    spirala:                            ; incepe folosirea matricei
        cmp dword[divided], 0           ; daca nu mai exista patrate
        je done_for_real

        mov esi, dword[lc]
        mov dword[newlc], esi

        cmp dword[poz], 0               ; daca ne aflam pe primul patrat,
        je loop1                        ; linia incepe de la K[0, 0]

        mov esi, dword[poz]
        mov edi, dword[lc]
        col_max:                        ; aici det. nr de pozitii in memorie
            cmp esi, 0                  ; necesare pt a sari peste o linie
            je next_poz                 ; trebuie sa fac acest lucru pt fiecare
            add dword[newlc], edi       ; patrat
            dec esi
        jmp col_max

        next_poz:

        mov esi, dword[poz]
        xor edi, edi
        move:                           ; aici calculez de unde incepe prima
            cmp esi, 0                  ; linie a patratului
            je loop1
            add edi, dword[lc]
            add edi, 8
            dec esi
        jmp move
        
        loop1:                          ; preia elementele de pe prima linie
            mov esi, dword[newlc]
            add esi, edi
            cmp edi, dword[newlc]
            jg next
            movzx esi, byte[ebx]        ; mut in esi litera din plain
            add esi, [ecx + edi]        ; adaug "step-ul" (din cheie)
            mov [edx], esi              ; inserez rezultatul in enc
            add edi, 4                  ; ma duc la urmatorul elem de pe linie
            inc ebx                     ; trec la urmatoarea  litera
            inc edx                     ; trec la urmatoarea cifra
        jmp loop1

        next:
        
        cmp eax, 1
        je done
        
        mov dword[max], eax             ; max - numarul de elemente de pe col

        mov edi, dword[newlc]           ; edi - pozitia primului element 
        add edi, dword[lc]              ; mai jos voi sari peste primul element
        add edi, 4                      ; de pe col, deja l-am folosit la loop1
        
        loop2:                          ; preia elementele de pe coloana N
            cmp dword[max], 1
            je next3
            movzx esi, byte[ebx]        ; analog ca la loop-ul anterior
            add esi, [ecx + edi]        
            mov [edx], esi
            inc ebx                     ; trec la urmatoarea  litera
            inc edx                     ; trec la urmatoarea cifra
            add edi, dword[lc]          ; practic ma duc la elementul de pe
            add edi, 4                  ; urmatoarea linie, aceeasi coloana
            dec dword[max]
        jmp loop2
        
        next3:
        sub edi, 8                      ; edi - pozitia primului element
        sub edi, dword[lc]              ; de pe linie
        
        mov dword[max], eax             ; retine nr de elem de pe linie
        mov esi, dword[poz]

        loop3:                          ; preia elementele de pe linia N 
            cmp dword[max], 1
            je next4
            movzx esi, byte[ebx]        ; shiftare
            add esi, [ecx + edi]
            mov [edx], esi
            sub edi, 4                  ; trec la elementul anterior
            dec dword[max]
            inc ebx                     ; trec la urmatoarea  litera
            inc edx                     ; trec la urmatoarea cifra
        jmp loop3
        next4:

        cmp eax, 2
        je done

        sub edi, dword[lc]
        mov dword[max], eax
        mov esi, dword[poz]
        sub dword[max], 2

        cmp eax, 2
        jg loop4

        mov dword[max], 2

        loop4:                          ; preia elementele de pe prima coloana
            cmp dword[max], 0
            jle done
            movzx esi, byte[ebx]
            add esi, [ecx + edi]
            mov [edx], esi                  ; inserez rezultatul in enc
            sub edi, dword[lc]              ; modific pozitia in memorie
            sub edi, 4                      ; practic ma duc cu o linie mai sus
            inc edx                         ; trec la urmatoarea cifra
            inc ebx                         ; trec la urmatoarea litera
            dec dword[max]
        jmp loop4
        
        done:
        sub eax, 2
        dec dword[divided]
        inc dword[poz]
    jmp spirala

    done_for_real:
    mov dword[poz], 0
    popa
    leave
    ret