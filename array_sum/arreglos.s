section	.data
; Definicion de constantes
LF		equ	10
NULL		equ	0
DOSPUNTOS equ 58

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
mil	 dq	1000
cien dq	100
diez dq	10

separador db 0
nombreArchivo   db "entrada.txt", NULL
archivoResultados   db  "salida.txt", NULL
vector_1Mensaje db "Vector 1: "
vector_2Mensaje db "Vector 2: "
mensajeSuma db "Suma (C=A+B): "
mensajeProductoPunto db  "Producto punto (N=A·B): "
descArchivo     dq 0
descResultados  dq 0
salto db ' ',LF
charActual db 0
numeroImprimible db 0,0,0,0,',',' '
numeroActual dq 0
suma dq 0
contador db 0
dividendo dq 0
cuentaIndices db 0

section .bss
vector1 resq 11
vector2 resq 11
sumaImprimible resb 30

section .text
global _start:
_start:
    push rbp
    mov rbp, rsp

    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

abrirArchivo:
    mov rax, SYS_open
    mov rdi, nombreArchivo
    mov rsi, O_RDONLY
    syscall ;Apertura en modo lectura

    cmp rax, 0
    jl errorAlAbrir

    mov qword[descArchivo], rax

crearArchivo:
    mov rax, SYS_creat 
    mov rdi, archivoResultados
    mov rsi, S_IRUSR | S_IWUSR
    syscall ;Creacion del archivo

    cmp rax, 0
    jl errorAlAbrir
    
    mov qword[descResultados], rax

imprimeMensajeVector1:
	mov rax,1
	mov rdi,1
	mov rsi,vector_1Mensaje
	mov rdx,10
	syscall

    ;guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, vector_1Mensaje
    mov rdx, 10
	syscall

	lea rsi,[vector1]
	push rsi

leerVector_1:
    mov qword[numeroActual], 0     ;guardamos 0 en la variable anioActual
    ;push rsi
    ;leemos byte que será para los millares
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

    cmp rax, 0
	jl	errorAlLeer
	
    lea rsi, [rel numeroImprimible]
    mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	qword [mil]
	add	qword [numeroActual], rax

    ;leemos byte que será para las centenas
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

	pop rsi
	cmp rax, 0
	jl	errorAlLeer

	mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	qword [cien]  ;byte si no jala
	add	qword [numeroActual], rax

    ;leemos byte que será para las decenas
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

	pop rsi
	cmp rax, 0
	jl	errorAlLeer

	mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	qword [diez] 
	add	qword [numeroActual], rax

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
	add	qword [numeroActual], rax

    ;leemos un byte mas que representa el separador de años ':'
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, separador
	mov	rdx, 1
	syscall

	cmp 	rax, 0
	jl	errorAlLeer
	;guardamos en vector 1
    pop rsi
	mov rax, qword[numeroActual]
    mov [rel rsi],rax
    inc rsi
    push rsi

	mov rax, qword[numeroActual]
	add qword[suma],rax

    ;imprimimos en consola
	mov rax,1
	mov rdi,1
	mov rsi,numeroImprimible
	mov rdx,6
	syscall

    ;guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, numeroImprimible
    mov rdx, 6
	syscall

	inc byte[cuentaIndices]
    ;pop rsi
    cmp byte [separador], LF ;Si separador == ':' leemos otro numero
    jne leerVector_1

imprimeMensajeVector2:
	mov rax,1
	mov rdi,1
	mov rsi,salto
	mov rdx,2
	syscall

	mov rax,1
	mov rdi,1
	mov rsi,vector_2Mensaje
	mov rdx,10
	syscall

    ;guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, salto
    mov rdx, 2
	syscall

	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, vector_2Mensaje
    mov rdx, 10
	syscall

    lea rsi,[vector2]
	push rsi

leerVector_2:
    mov qword[numeroActual], 0     ;guardamos 0 en la variable anioActual
    ;push rsi
    ;leemos byte que será para los millares
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

    cmp rax, 0
	jl	errorAlLeer
	
    lea rsi, [rel numeroImprimible]
    mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	qword [mil]
	add	qword [numeroActual], rax

    ;leemos byte que será para las centenas
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

	pop rsi
	cmp rax, 0
	jl	errorAlLeer

	mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	qword [cien]  ;byte si no jala
	add	qword [numeroActual], rax

    ;leemos byte que será para las decenas
	push rsi
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, charActual
	mov	rdx, 1
	syscall

	pop rsi
	cmp rax, 0
	jl	errorAlLeer

	mov	al, byte [charActual]
	mov byte [rel rsi], al
	inc rsi
	sub	al, 48
	mov	ah, 0
	mul	qword [diez] ;byte si no jala
	add	qword [numeroActual], rax

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
	add	qword [numeroActual], rax

    ;leemos un byte mas que representa el separador de años ':'
    mov	rax, SYS_read
	mov	rdi, qword[descArchivo]
	mov	rsi, separador
	mov	rdx, 1
	syscall

	cmp 	rax, 0
	jl	errorAlLeer

	;guardamos en vector 2
    pop rsi
    mov rax, qword[numeroActual]
    mov [rel rsi],rax
    inc rsi
    push rsi

	mov rax, qword[numeroActual]
	add qword[suma],rax

    ;imprimimos en consola
	mov rax,1
	mov rdi,1
	mov rsi,numeroImprimible
	mov rdx,6
	syscall

    ;guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, numeroImprimible
    mov rdx, 6
	syscall

    ;pop rsi
    cmp byte [separador], LF ;Si separador == ':' leemos otro numero
    jne leerVector_2

imprimeSuma:
	mov rax,1
	mov rdi,1
	mov rsi,salto
	mov rdx,2
	syscall

	mov rax,1
	mov rdi,1
	mov rsi,mensajeSuma
	mov rdx,14
	syscall

	lea rsi, [sumaImprimible]
    mov rax, qword[suma] 
	call imprimeNumero

	;guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, salto
    mov rdx, 2
	syscall

	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, mensajeSuma
    mov rdx, 14
	syscall

	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, sumaImprimible
    mov rdx, 6
	syscall

imprimeProductoPunto:
	lea rsi,[vector1]
	lea rdi,[vector2]
	mov qword[suma], 0
	
	productoPunto:
		mov rax, qword[rsi]
		mov rbx, qword[rdi]
		mul rbx

		add qword[suma],rax
		inc rsi
		inc rdi 
		dec byte[cuentaIndices]
		mov cl, byte[cuentaIndices]
		cmp cl,0
		jne productoPunto
	
	mov rax,1
	mov rdi,1
	mov rsi,mensajeProductoPunto
	mov rdx,24
	syscall

	lea rsi, [sumaImprimible]
    mov rax, qword[suma] 
	call imprimeNumero

	;guardamos en archivo
	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, salto
    mov rdx, 2
	syscall

	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, mensajeProductoPunto
    mov rdx, 24
	syscall

	mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, sumaImprimible
    mov rdx, 20
	syscall

cerrarArchivos:
	
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, LF
    mov rdx, 1
    syscall

    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, LF
    mov rdx, 1
    syscall

    
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

imprimeNumero:
	push rbp
	mov	rbp, rsp
	push rbx

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
      
    incrementaIndice:
        pop rdx
        mov [rsi], rdx
        dec byte[contador]
        inc rsi
        mov bl, byte[contador]
        cmp bl, 0
        jne  incrementaIndice
    
    mov byte[contador], 0
    mov rax,1
	mov rdi,1
	mov rsi,sumaImprimible
	mov rdx,30
	syscall
    
    mov rax,1
	mov rdi,1
	mov rsi,salto
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