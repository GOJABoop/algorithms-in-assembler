BITS 64
section	.data align=16
;Definicion de constantes
LF		    equ	10
NULL		equ	0

;Variables particulares de programa
frv:    db  "%f + j%f",LF,NULL

;Reserva de memoria
section .bss align=16
matriz_a    resq 2
temp        resq 2

section .text align=16
extern printf
global multiplicaComplejos:
multiplicaComplejos:
    push rbp
    mov rbp, rsp
    sub rsp, 128

    mov rbx, rdi
    movups xmm1, [rbx]
    mov rbx, matriz_a
    movups [rbx], xmm1

    mov rbx, rsi
    movups xmm2, [rbx]

    mulps xmm1, xmm2
    movaps [rel temp], xmm1
    movss xmm3, [rel temp]
    movss xmm4, [rel (temp+4)]
    subss xmm3,xmm4
    movss xmm0,xmm3

    movups xmm1, [rel matriz_a]
    shufps xmm2, xmm2, 0b10110001
    mulps xmm1, xmm2
    movaps [rel temp], xmm1
    movss xmm3, [rel temp]
    movss xmm4, [rel (temp+4)]
    addss xmm3, xmm4
    movss xmm1, xmm3

    cvtss2sd xmm0,xmm0
    cvtss2sd xmm1,xmm1
    mov rdi, frv
    mov rax, 2
    call printf WRT ..plt
    
    add rsp, 128
    mov rsp, rbp
    pop rbp
    ret