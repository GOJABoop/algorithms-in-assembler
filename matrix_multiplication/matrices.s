BITS 64
section .data align=16
cuatro dq 4
i db 0
j db 0

section .bss align=16
resultado resq 16

section .text align=16
global multiplicacionMatriz
multiplicacionMatriz:
    push rbp
    mov rbp, rsp
    sub rsp, 128

    mov r8, 0
    mov rcx, rdi  
    for_i:
        mov rdx, rsi
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
        je terminar
        add rcx, 16
        jmp for_i

terminar:
    mov rax, resultado
    add rsp, 128
    mov rsp, rbp
    pop rbp
    ret
