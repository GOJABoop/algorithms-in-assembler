section .data  ;variables y constantes

LF equ 10
NULL    equ 0

TRUE    equ 1
FALSE   equ 0
EXIT_SUCCESS    equ 0
STDIN   equ 0 ;Entrada consola
STDOUT  equ 1
STDERR  equ 2

SYS_read    equ 0
SYS_write   equ 1
SYS_open    equ 2
SYS_close   equ 3
SYS_exit    equ 60
SYS_creat   equ 85

O_CREAT     equ 0x40
O_TRUNC     equ 0x200
O_APPEND    equ 0x400

O_RDONLY    equ 000000q
O_WRONLY    equ 000001q
O_RDWR      equ 000002q

S_IRUSR     equ 00400q
S_IWUSR     equ 00200q
S_IXUSR     equ 00100q

BUFF_SIZE   equ 1

;Definicion de variables

decena      dw 10
unidad      db 1

endl    db  LF, NULL
separador db ':'

nombreArchivo   db "numeros.txt", NULL
descArchivo     dq 0
descResultados  dq 0

contNumero  db 0
numeroTemp  db 0
numeroActual  db  0,0,0
charActual  db  0
arraySize db 10
residuo db 0

msjErrorAbrir   db  "Error abriendo el archivo.", LF, NULL
msjErrorLeer    db  "Error leyendo el archivo.", LF, NULL
msjErrorEsc     db  "Error escribiendo el archivo", LF, NULL

archivoResultados   db  "resultados.txt", NULL
esBisiestoBool      db FALSE

;reserva de memoria
section .bss 
numerosLeidos   resb  12

;codigo
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
    lea rsi, [rel numeroActual]
    lea rdi,[rel numerosLeidos]

leerCharArchivo:
    push rsi ;Guardar valor del indice de numeroActual
    push rdi ;Guardar valor del indice de numerosLeidos
    mov rax, SYS_read
    mov rdi, qword[descArchivo]
    mov rsi, charActual
    mov rdx, 1
    syscall
    
    pop rdi ;Recuperar el valor del indice de numeroActual
    pop rsi ;Recuperar el valor del indice de numerosLeidos
    cmp rax, 0
    jl errorAlLeer

    jmp checarNumero

    
checarNumero:
    mov al, byte [charActual]
    cmp al, 0x3A
    je convertirNumero
    cmp al, LF
    je convertirNumero
    ;Guardar en el buffer
    mov byte [rel rsi], al
    inc rsi ;Incrementamos el tamanio del buffer
    jmp leerCharArchivo
    
convertirNumero:
    dec rsi
    cmp byte [rel contNumero], 1 ;Si es != 0 es mas de un digito
    je mulDecena
    inc byte [rel contNumero]
    xor al, al
    mov al, byte [rsi] ;Guardar el valor de numeroActual
    sub al, 0x30        ;Generar valor numerico
    add byte [rel numeroTemp], al
    cmp rsi, numeroActual
    je esUnDigito
    jmp convertirNumero
    esUnDigito:
    xor al, al
    mov al, byte [rsi]
    sub al, 0x30
    mov byte [rdi], al
    inc rdi
    mov byte [rel numeroTemp], NULL
    mov byte [rel contNumero], NULL
    lea rsi, [rel numeroActual]
    jmp leerCharArchivo

mulDecena:
    xor al, al
    mov al, byte [rsi]
    sub al, 0x30
    xor rbx, rbx
    mov bl, byte [decena]
    mul bl
    add al, byte [rel numeroTemp]
    mov byte [rdi], al
    inc rdi
    mov byte [rel numeroTemp], NULL
    mov byte [rel contNumero], NULL
    lea rsi, [rel numeroActual]
    cmp byte [charActual], LF
    je ordenamiento
    jmp leerCharArchivo


;Ordenamiento del arreglo

ordenamiento:
    xor rdx, rdx
    xor rbx, rbx
    xor rcx, rcx
    xor rax, rax
    mov dl, byte [rel arraySize]

    for_i:
        mov cl, byte [rel arraySize]
        lea rsi, [rel numerosLeidos]

        for_j:
            mov al, byte [rel rsi]
            cmp al, byte [rel rsi+1]
            jl esMenor
            mov bl, al
            mov al, byte [rel rsi+1]
            mov byte [rel rsi], al
            mov byte [rel rsi+1], bl
        esMenor:
            inc rsi
            loop for_j
    dec rdx
    jnz for_i
    jmp escribirResultados

escribirResultados:
    mov byte [contNumero], 0
    add byte [rel arraySize], 1
    lea rsi,[rel numerosLeidos] ; Indice inicial de numerosLeidos    
    dividirNumero:
    xor rax, rax
    xor rbx, rbx
    xor rdx, rdx
    mov al, [rel rsi]  ;Dividendo
    mov byte [numeroTemp], al 
    mov bl, byte [decena]   ;Divisor 
    div bl  ;Residuo se guarda en ah y el resultado al
    mov byte [residuo], ah ;Respaldo del residuo
    push rsi ;Guardamos el valor del indice de numerosLeidos
    cmp al, NULL ;Si resultado es 0
    je imprimirResiduo
    ;Imprimir resultado
    mov byte [charActual], al
    add byte [charActual], 0x30
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, charActual
    mov rdx, 1
    syscall
    ;Escribir archivo
    mov rax, SYS_write
    mov rdi, qword[descResultados]
    mov rsi, charActual
    mov rdx, 1
    syscall
    ;Volver a dividir
    xor rax, rax
    xor rbx, rbx
    xor rdx, rdx
    mov al, byte [residuo]
    mov bl, byte [decena]
    div bl

    imprimirResiduo: 
    ;Imprimir residuo
    mov byte [charActual], ah
    add byte [charActual], 0x30
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, charActual
    mov rdx, 1
    syscall
    ;Escrbir residuo
    mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, charActual
    mov rdx, 1
    syscall

    ;Imprimir salto linea
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, separador
    mov rdx, 1
    syscall
    ;Escribir salto de linea
    mov rax, SYS_write
    mov rdi, qword [descResultados]
    mov rsi, separador
    mov rdx, 1
    syscall

    pop rsi
    inc rsi
    inc byte [contNumero]
    mov al, byte [rel contNumero]
    cmp al, byte [rel arraySize]
    jne dividirNumero

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
    mov rax, 60
    mov rdi, 0
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
