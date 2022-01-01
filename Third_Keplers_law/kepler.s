BITS 64
section	.data
LF		    equ	10
NULL		equ	0
STDOUT		equ	1
SYS_exit	equ	60
EXIT_SUCCESS equ 0
formato         db "%f",LF,NULL
const_terrestre dq 1.0
k   dq 0.997;constante promedio de las constantes de los planetas

section .bss
T   resq 2  ;periodo de orbita respecto al año terrestre
semieje   resq 2  ;radio de la orbita al sol

section .text
extern printf
global terceraLeyDeKepler:
terceraLeyDeKepler:
    push rbp
	mov	 rbp, rsp
    ;llegan los parametros en xmm0 = semieje
    movsd qword[rel semieje], xmm0

    ucomisd xmm0, [rel const_terrestre]
    je anioTerrestre

    fld qword[rel semieje]
    fld qword[rel semieje]
    fmul
    fld qword[rel semieje]
    fmul
    fld qword[rel k]
    fmul
    fsqrt
    fstp qword[rel T]
    movsd xmm0,[rel T] ; necesario para printf

    ;imprimimos el resultado
    ;en xmm0 debe estar el resultado
    mov rax, 1
    mov rdi, formato
    mov rsi, T
    call printf wrt ..plt
    jmp funcionTerminada

    anioTerrestre:  
    mov rax, 1
    mov rdi, formato
    mov rsi, const_terrestre
    call printf wrt ..plt

    funcionTerminada:
    mov rsp, rbp
    pop	rbp
    ret

