%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  		; len
    mov     esi, [ebp + 12]		; plain
    mov     edi, [ebp + 16] 		; enc_string
    mov     edx, [ebp + 20] 		; step

    xor ebx, ebx
    shift:
        xor eax, eax
        mov al, byte[esi + ebx]  	 ; mut caracterul in registrul al
        add al, dl                  			 ; adaug step ul
        cmp al, "Z"                 		 ; daca dupa step caracterul nu mai este
        jg modify                   		 ; litera mare, scad 26
        back:
        mov [edi + ebx], al        	 ; introduc la adresa lui enc_string caracterul
        add ebx, 1                 		 ; ma duc la urmatorul caracter
    loop shift

    cmp ecx, 0
    je done

    modify:
    sub al, 26                    			 ; scad 26 pentru a avea o litera mare
    jmp back

    done:

    popa
    leave
    ret