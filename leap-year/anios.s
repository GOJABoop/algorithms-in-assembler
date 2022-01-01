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

; Declaracion/Definicion de variables
newLine		db	LF, NULL

msjErrorAbrir	db	"Error al abrir el archivo.", LF, NULL
msjErrorLeer	db	"Error al leer del archivo.", LF, NULL
msjErrorEsc	db	"Error al escribir al archivo.", LF, NULL

;variables particulares de programa
mil	 dw	1000
cien dw	100
diez dw	10

nombreArchivo	db	"bisiesto.txt", NULL
resultados	db	"resultados_bisiesto.txt", NULL
descArchivo	dq	0
descResultados	dq	0

anioActual	dw	0
charActual	db	0
separador db 0
espacio db " "
anioImprimible db 0,0,0,0,' '

msjEsBisiesto	db	"es bisiesto", LF, NULL
msjNoBisiesto	db	"no es bisiesto", LF, NULL

section .text
global _start
_start:
    push rbp
    mov rbp, rsp

    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

abrirArchivo:
	mov	rax, SYS_open
	mov	rdi, nombreArchivo
	mov	rsi, O_RDONLY
	syscall 

	cmp	rax, 0
	jl	errorAlAbrir

	mov	qword[descArchivo], rax

crearArchivo:
	mov	rax, SYS_creat
	mov	rdi, resultados
	mov	rsi, S_IRUSR | S_IWUSR
	syscall

	cmp	rax, 0
	jl	errorAlAbrir

	mov	qword [descResultados], rax

leerAnio:
    mov word[anioActual], 0     ;guardamos 0 en la variable anioActual
    
    ;leemos byte que será para los millares
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

	cmp rax, 0
	jl	errorAlLeer
	lea rsi, [rel anioImprimible]

    mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	word [mil]
	add	word [anioActual], ax
    
    ;leemos byte que será para las centenas
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

	pop rsi
	cmp 	rax, 0
	jl	errorAlLeer

	mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	word [cien]  ;byte si no jala
	add	word [anioActual], ax

    ;leemos byte que será para las decenas
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

	pop rsi
	cmp 	rax, 0
	jl	errorAlLeer

	mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	word [diez] ;byte si no jala
	add	word [anioActual], ax

    ;leemos byte que será para las unidades
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall
	
	pop rsi
	cmp 	rax, 0
	jl	errorAlLeer

	mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	add	word [anioActual], ax

    ;leemos un byte mas que representa el separador de años ':'
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, separador
	mov	rdx, 1
	syscall

	pop rsi
	cmp 	rax, 0
	jl	errorAlLeer

evaluaAnio:
    xor rax,rax ;limpiamos los registros para la operacion
	xor rbx,rbx
	xor rdx,rdx

    mov rax,[rel anioActual]	;cargar el año
	mov rbx,0x0190  ;divisor 400d
	div rbx         ;dividimos
	cmp rdx,0       ;en dx se guarda el residuo si es 0 es bisisesto
    je esBisiesto   ;si el residuo dx es cero es anio bisisesto

	xor rax,rax ;limpiamos los registros para la operacion
	xor rbx,rbx
	xor rdx,rdx

    mov rax, [rel anioActual]	;cargar el año
	mov rbx,0x04    ;divisor
	div rbx         ;dividimos
	cmp rdx,0       ;en dx se guarda el residuo si es 0 continuamos
    jne noEsBisiesto ;si el residuo dx no es cero salta a la segunda evaluacion
	
	xor rax,rax ;limpiamos los registros para la operacion
	xor rbx,rbx
	xor rdx,rdx

    mov rax,[rel anioActual]	;cargar el año
	mov rbx,0x64    ;divisor 100d
	div rbx         ;dividimos
	cmp rdx,0       ;comparamos
    je noEsBisiesto ;si el residuo es cero, no es bisisesto
    ;si llegamos aqui es bisiesto y continua    

esBisiesto:
    ;imprimimos en consola
	mov rax,1
	mov rdi,1
	mov rsi,anioImprimible
	mov rdx,5
	syscall

    mov rax,1
	mov rdi,1
	mov rsi,msjEsBisiesto
	mov rdx,12
	syscall

    ;guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, anioImprimible
    mov rdx, 5
	syscall

    mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, msjEsBisiesto
    mov rdx, 12
    syscall

    cmp byte [separador], LF ;Si separador == '\n' llegamos al final del txt
    jne leerAnio
    jmp cerrarArchivos


noEsBisiesto:
    ;Imprimimos en consola
	mov rax,1
	mov rdi,1
	mov rsi,anioImprimible
	mov rdx,5
	syscall

    mov rax,1
	mov rdi,1
	mov rsi,msjNoBisiesto
	mov rdx,15
	syscall

    ;Guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, anioImprimible
    mov rdx, 5
	syscall

    mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, msjNoBisiesto
    mov rdx, 15
    syscall

    cmp byte [separador], LF ;Si separador == '\n' llegamos al final del txt
    jne leerAnio

cerrarArchivos:
    mov rax, SYS_close
    mov rdi, qword [descResultados]
    syscall
    
    mov rax, SYS_close
    mov rdi, qword [descArchivo]
    syscall 

final:
    pop rbp
    mov rsp, rbp

    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

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
