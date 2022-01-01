section	.data
; Definicion de constantes
LF		equ	10
NULL		equ	0

TRUE		equ	1
FALSE		equ	0
EXIT_SUCCESS	equ	0
STDIN		equ	0
STDOUT		equ	1
STDERR		equ	2

SYS_read	equ	0
SYS_write	equ	1
SYS_open	equ	2
SYS_close	equ	3
SYS_fork	equ	57
SYS_exit	equ	60
SYS_creat	equ	85
SYS_time	equ	201

O_CREAT		equ	0x40
O_TRUNC		equ	0X200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q
O_WRONLY	equ	000001q
O_RDWR		equ	000002q

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

;Declaracion/Definicion de variables
newLine		db	LF, NULL

msjErrorAbrir	db	"Error al abrir el archivo.", LF, NULL
msjErrorLeer	db	"Error al leer del archivo.", LF, NULL
msjErrorEsc	db	"Error al escribir al archivo.", LF, NULL

;variables particulares de programa
STRLEN  equ 2
cadIngresaNumero db "Ingresa el termino maximo de la serie (46 max): ", NULL
valorNumerico db 0
diez db	10
seCastearonUnidades db FALSE
f_1 dq 1
f_2 dq 1
contador db 0
dividendo dq 0
;numeroImprimible db "holacomoes"

section .bss
caracter resb 1
numero resb STRLEN+1 ; total de 3 = 0,0,'\0'
numeroImprimible resb 30

section .text
global _start:
_start:
    push rbp
    mov rbp, rsp

    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    ;Muestra mensaje
    mov rdi, cadIngresaNumero
    call imprimirString

    ;leer digito por digoto el termino de la serie
    mov rbx, numero     ;direccion de numero
    mov r12, 0          ;contador en r12 = 0
    
leeDigitos:
    mov rax, SYS_read   ;codigo para leer
    mov rdi, STDIN      ;entrada (standard in)
    lea rsi, [caracter] ;direccion de caracter se guarda el valor en caracter
    mov rdx, 1          ;cuantos bytes leeremos
    syscall             
    
    mov al, byte [caracter]  ;mover valor de caracter
    cmp al, LF          ;Si linefeed (enter), entrada terminada
    je entradaTerminada
    
    cmp r12, STRLEN     ;if # digitos(contador) ≥ STRLEN
    jae leeDigitos      ;stop placing in buffer
    
    mov byte [rbx], al  ;numero[i] = caracter(digito)
    inc r12             ;contador++
    inc rbx             ; actualizamos la direccion de numero (siguiente indice)
    
    jmp leeDigitos

entradaTerminada:
    mov byte [rbx], NULL ;agrega NULL al final de numero 
    dec rbx
    ;mov rdi, numero;
    ;call imprimirString

casteaNumero:
    cmp r12, 2
    je casteaUnidades

    cmp r12, 1
    je casteaDecenas

    cmp r12, 0
    je serieFibonacci


casteaUnidades:
    mov al, byte [rbx]
    sub al, 48
    mov byte [valorNumerico], al

    dec r12
    dec rbx
    mov byte [seCastearonUnidades], 1
    jmp casteaNumero

casteaDecenas:
    cmp byte [seCastearonUnidades], 0
    je casteaUnidades

    mov al, byte[rbx]
    sub al, 48
    mul byte [diez]

    add al, byte [valorNumerico]
    mov byte [valorNumerico], al
    dec r12
    jmp casteaNumero

serieFibonacci:
    call imprimeSiguienteNumero  ;imprime f_1 = 1
    dec byte[valorNumerico]
    for_i:
        call imprimeSiguienteNumero  ;imprime f_2
        mov rax, qword[f_1] 
        add qword[f_2], rax         ; f_2 = f_2 + f_1

        mov rax, qword[f_2]
        sub rax, qword[f_1]
        mov qword[f_1], rax         ; f_1 = f_2 - f_1

        dec byte[valorNumerico]
        cmp byte[valorNumerico], 0
        jne for_i

final:
    pop rbp
    mov rsp, rbp

    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

imprimeSiguienteNumero:
    push	rbp
	mov	rbp, rsp
	push	rbx

    lea rsi, [numeroImprimible]
    mov rax, qword[f_2] 
    mov qword[dividendo], rax 
    
    convierteNumero:
        xor rax, rax
        xor rbx, rbx
        xor rdx, rdx
        mov rax, qword[dividendo]
        mov rbx, 10
        div rbx

        add rdx,48
        push rdx
        add byte[contador], 1

        mov qword[dividendo],rax
        cmp rax, 0
        jne convierteNumero
      
    ;mov bh, byte[contador]
    incrementaRsi:
        pop rdx
        mov [rsi], rdx
        dec byte[contador]
        inc rsi
        mov bl, byte[contador]
        cmp bl, 0
        jne  incrementaRsi
    
    mov byte[contador], 0
    mov rax,1
	mov rdi,1
	mov rsi,numeroImprimible
	mov rdx,10
	syscall
    
    mov rax,1
	mov rdi,1
	mov rsi,newLine
	mov rdx,2
	syscall
    
    pop	rbx
	pop	rbp
    ret

errorAlAbrir:
    mov rdi, msjErrorAbrir
    call imprimirString
    jmp pruebaTerminada

errorAlLeer:
    mov rdi, msjErrorLeer
    call imprimirString
    jmp pruebaTerminada

errorAlEscribir:
    mov rdi, msjErrorEsc
    call    imprimirString

    jmp pruebaTerminada

pruebaTerminada:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

global imprimirString
imprimirString:
	push	rbp
	mov	rbp, rsp
	push	rbx

; Contamos los caracteres

	mov	rbx, rdi
	mov	rdx, 0
    conteoCharsLoop:
	cmp	byte [rbx], NULL
	je	conteoCharsTerminado
	inc	rdx
	inc	rbx
	jmp	conteoCharsLoop
    conteoCharsTerminado:
	cmp	rdx, 0
	je	parteTerminada

; Imprimimos la cadena

	mov	rax, SYS_write
	mov	rsi, rdi
	mov	rdi, STDOUT

	syscall

   parteTerminada:
	pop	rbx
	pop	rbp
	ret
