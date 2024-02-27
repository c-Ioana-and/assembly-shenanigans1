%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global points_distance
    extern printf

points_distance:
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]          				; points
    mov eax, [ebp + 12]         			; distance

    xor ecx, ecx
    xor edx, edx

    mov cl, byte[ebx + point.x]
    mov ch, byte[ebx + 4 + point.x]   	 ; retin abcisele celor doua puncte
    cmp cl, ch                         				 ; daca se afla pe aceeasi axa verticala,
    je distance_y                       				 ; calculez  distanta folosind ymax - ymin
    
    mov cl, byte[ebx + point.y]
    mov ch, byte[ebx + 4 + point.y]    	  ; retin ordonatele celor doua puncte
    cmp cl, ch                       				  ; daca se afla pe aceeasi axa orizontala,
    je distance_x                    				  ; calculez distanta folosind xmax - xmin

    xor ecx, ecx

    distance_x:                         				; calculez distanta dintre abcise
    mov cl, byte[ebx + 4 + point.x]
    mov ch, byte[ebx + point.x]
    add dl, cl
    cmp cl, ch
    jl switch                         					; interschimb pt ca distanta sa fie pozitiva
    sub dl, ch                          				; daca da, fac diferenta si gata
    
    jmp done                           				; ajung aici daca distanta este facuta

    xor edx, edx

    xor ecx, ecx
    xor edx, edx

    distance_y:                         				; calculez distanta dintre ordonate
    mov cl, byte[ebx + 4 + point.y]
    mov ch, byte[ebx + point.y]
    add dl, cl
    cmp cl, ch
    jl switch
    sub dl, ch
    
    jmp done

    xor edx, edx
    switch:
    mov dl, ch
    sub dl, cl

    done:
    mov [eax], edx

    popa
    leave
    ret
