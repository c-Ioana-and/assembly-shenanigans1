%include "../include/io.mac"

section .data
    distance: db 0
struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global road
    extern printf

road:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]     				 ; points
    mov ecx, [ebp + 12]     				; len
    mov ebx, [ebp + 16]     				; distances
    
    calc_dist:
        cmp ecx, 1
        je done
        xor edx, edx
        mov byte[distance], 0
        mov dl, byte[eax + point.x]
        mov dh, byte[eax + 4 + point.x]       ; retin x-urile celor doua puncte
        cmp dl, dh                         			   ; daca se afla pe axa OX, calculez 
        je distance_y                    			   ; distanta folosind ymax - ymin
        
        mov dl, byte[eax + point.y]
        mov dh, byte[eax + 4 + point.y]      ; retin y-urile celor doua puncte
        cmp dl, dh                         			  ; daca se afla pe axa OY, calculez
        je distance_x                      			  ; distanta folosind xmax - xmin

        calculated:						 ; am distanta calculata in distance
        xor edx, edx
        add dl, byte[distance]
        mov [ebx], edx
        add ebx, 4
        add eax, 4
    loop calc_dist

    distance_x:                    		     		 ; calculez distanta dintre x-uri
    mov dl, byte[eax + 4 + point.x]
    mov dh, byte[eax + point.x]
    add byte[distance], dl
    cmp dl, dh
    jl switch                           				 ; interschimb pt ca distanta sa fie pozitiva
    sub byte[distance], dh         		         ; daca este deja pozitiva
    jmp calculated                     			 ; atunci ma intorc in loop

    distance_y:                         				; calculez distanta dintre y-uri
    mov dl, byte[eax + 4 + point.y]
    mov dh, byte[eax + point.y]
    add byte[distance], dl
    cmp dl, dh
    jl switch
    sub byte[distance], dh
    jmp calculated                     			 ; ma intorc in loop daca distanta e deja ok

    switch:
    mov byte[distance], dh
    sub byte[distance], dl
    jmp calculated                      			; iar ma intorc in loop

    done:
    popa
    leave
    ret