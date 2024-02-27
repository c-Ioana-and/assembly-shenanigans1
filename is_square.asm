%include "../include/io.mac"

section .data
    sum: dw 0

section .text
    global is_square
    extern printf

is_square:
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; dist
    mov eax, [ebp + 12]     ; nr
    mov ecx, [ebp + 16]     ; sq
    
    xor edx, edx
    xor esi, esi
    xor edi, edi
    check_if_square:
        mov edx, [ebx]
        cmp edx, 0
        je good

        mov esi, 0
        mov edi, 0

        recalculate:
        inc esi                     			; esi si edi vor fi practic un i
        mov edi, esi                		; la sum il voi adauga i de i ori
        mov dword[sum], 0             ; pentru a obtine patratul lui i

        square:
            cmp dword[sum], edx    ; daca suma devine mai mare decat nr
            jg bad                  			; atunci distanta nu este patrat perfect
            cmp edi, 0
            je calculated
            add dword[sum], esi     	; in sum voi retine patratul numarului
            dec edi
        jmp square

        calculated:                		 ; am calculat patratul perfect al lui i
        cmp dword[sum], edx
        jl recalculate              		; daca e prea mic, cresc i-ul si recalculez

        cmp dword[sum], edx
        jg bad                      			; i^i prea mare, dist nu este patrat perf

        good:                      			 ; a ajuns aici-> am gasit patratul perfect
        mov dword[ecx], 1
        jmp next                   			 ; trec la urmatoarea distanta

        bad:
        mov dword[ecx], 0          	 ; distanta nu e patrat perfect

        next:
        add ebx, 4                			 ; trec la urmatoarea distanta
        add ecx, 4                 			 ; trec la urmatoarea adresa square
        dec eax
        cmp eax, 0
        je done
    jmp check_if_square

    done:
    popa
    leave
    ret