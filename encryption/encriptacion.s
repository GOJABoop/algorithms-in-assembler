BITS 64
section .data align=16
formato db "%f %f %f %f",10,0
formatoInt db "%.0f %.0f %.0f %.0f",10,0
formatoAscii db "%c "
msjMatrizEncriptada db "Matriz encriptada",10,0
msjMAtrizEncriptacion db 10,"Matriz encriptacion",10,0
msjMatrizDesencriptacion db 10,"Matriz desencriptacion (inversa)",10,0
msjMatrizMensaje db 10,"Matriz mensaje ASCII",10,0

cuatro dq 4
i db 0
j db 0
matrizMensaje dd 72.0,76.0,67.0,82.0,79.0,79.0,65.0,79.0,76.0,76.0,67.0,76.0,65.0,65.0,69.0,65.0

matrizAscii db 72,76,67,82,79,79,65,79,76,76,67,76,65,65,69,65

matrizEncriptacion dd -2.0, 1.0, 8.0, 0.0,-3.0, 0.0, 1.0, 4.0, 2.0, 1.0, 1.0,-3.0, 4.0, 5.0, 0.0, 0.0

matrizDesencriptacion dd 0.5, -1.714285714, -2.285714286, 0.3571428571, -1.12, 1.371428571, 1.828571429, -0.08571428571, 0.3, -0.6, -0.8, 0.1, 0.3,  -0.8857142857, -1.514285714, 0.2428571429

section .bss align=16
resultado resq 16

section .text align=16
extern printf
global main:
main:
    push rbp
    mov rbp, rsp
    sub rsp, 128

    mov r8, 0
    mov rcx, matrizMensaje
    for_i:
        mov rdx, matrizEncriptacion
        xor rax, rax
        mov rax, 0
        mov byte[rel j], al  
        for_j:
            mov rbx, rcx
            movups xmm1, [rbx]
            mov rbx, rdx
            movups xmm2, [rbx]
            mulps xmm1, xmm2
            haddps xmm1,xmm2
            haddps xmm1,xmm1 
            movss [rel resultado+r8], xmm1 
            add r8, 4
            add rdx, 16
            xor rax, rax
            mov rax, qword[rel cuatro]
            inc byte[rel j]
            cmp byte[rel j], al
            jne for_j
        inc byte[rel i] 
        mov rax, qword[rel cuatro]
        cmp byte[rel i], al
        je imprimir
        add rcx, 16
        jmp for_i

imprimir:
    mov rdi, msjMatrizEncriptada
    mov rax, 0
    call printf WRT ..plt
    mov byte[rel i], 0
    mov byte[rel j], 0
    for_k:
        xor rbx, rbx
        xor rcx, rcx
        mov rbx, 4
        mov cl, byte[rel j]
        movss xmm0, [rel resultado+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm1, [rel resultado+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm2, [rel resultado+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm3, [rel resultado+rcx]
        add byte[rel j], bl
        inc byte[rel i]
        cvtss2sd xmm0,xmm0
        cvtss2sd xmm1,xmm1
        cvtss2sd xmm2,xmm2
        cvtss2sd xmm3,xmm3
        mov rdi,formato
        mov rax,4
        call printf WRT ..plt
        mov al, byte[rel cuatro]
        cmp byte[rel i],al
        jne for_k


    mov rdi, msjMAtrizEncriptacion
    mov rax, 0
    call printf WRT ..plt
    mov byte[rel i], 0
    mov byte[rel j], 0
    for_l:
        xor rbx, rbx
        xor rcx, rcx
        mov rbx, 4
        mov cl, byte[rel j]
        movss xmm0, [rel matrizEncriptacion+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm1, [rel matrizEncriptacion+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm2, [rel matrizEncriptacion+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm3, [rel matrizEncriptacion+rcx]
        add byte[rel j], bl
        inc byte[rel i]
        cvtss2sd xmm0,xmm0
        cvtss2sd xmm1,xmm1
        cvtss2sd xmm2,xmm2
        cvtss2sd xmm3,xmm3
        mov rdi,formato
        mov rax,4
        call printf WRT ..plt
        mov al, byte[rel cuatro]
        cmp byte[rel i],al
        jne for_l

    mov rdi, msjMatrizDesencriptacion
    mov rax, 0
    call printf WRT ..plt
    mov byte[rel i], 0
    mov byte[rel j], 0
    for_m:
        xor rbx, rbx
        xor rcx, rcx
        mov rbx, 4
        mov cl, byte[rel j]
        movss xmm0, [rel matrizDesencriptacion+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm1, [rel matrizDesencriptacion+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm2, [rel matrizDesencriptacion+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm3, [rel matrizDesencriptacion+rcx]
        add byte[rel j], bl
        inc byte[rel i]
        cvtss2sd xmm0,xmm0
        cvtss2sd xmm1,xmm1
        cvtss2sd xmm2,xmm2
        cvtss2sd xmm3,xmm3
        mov rdi,formato
        mov rax,4
        call printf WRT ..plt
        mov al, byte[rel cuatro]
        cmp byte[rel i],al
        jne for_m

    mov rdi, msjMatrizMensaje
    mov rax, 0
    call printf WRT ..plt
    mov byte[rel i], 0
    mov byte[rel j], 0
    for_n:
        xor rbx, rbx
        xor rcx, rcx
        mov rbx, 4
        mov cl, byte[rel j]
        movss xmm0, [rel matrizMensaje+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm1, [rel matrizMensaje+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm2, [rel matrizMensaje+rcx]
        add byte[rel j], bl
        mov cl, byte[rel j]
        movss xmm3, [rel matrizMensaje+rcx]
        add byte[rel j], bl
        inc byte[rel i]
        cvtss2sd xmm0,xmm0
        cvtss2sd xmm1,xmm1
        cvtss2sd xmm2,xmm2
        cvtss2sd xmm3,xmm3
        mov rdi,formatoInt
        mov rax,4
        call printf WRT ..plt
        mov al, byte[rel cuatro]
        cmp byte[rel i],al
        jne for_n

terminar:
    add rsp, 128
    mov rsp, rbp
    pop rbp

    mov rax, 60
    mov rdi, 0
    syscall
