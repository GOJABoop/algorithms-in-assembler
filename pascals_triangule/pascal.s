section	.data
;Definicion de constantes
LF		    equ	10
NULL		equ	0
TRUE		equ	1
FALSE		equ	0
EXIT_SUCCESS equ 0
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
newLine		    db	LF, NULL
msjErrorAbrir	db	"Error al abrir el archivo.", LF, NULL
msjErrorLeer	db	"Error al leer del archivo.", LF, NULL
msjErrorEsc	    db	"Error al escribir al archivo.", LF, NULL

;Variables/constantes particulares de programa
STRLEN              equ 2
cadIngresaNumero    db "Ingresa el n-esimo termino del triangulo (12 max): ", NULL
salto               db ' ',LF
espacio             db " "
valorNumerico       db 0
diez                db 10
seCastearonUnidades db FALSE
fila                db 1
contador            db 0
elemento            dq 1
dividendo           dq 0
facto_m             dq 0
facto_n             dq 0
multiplicador       dq 0
i                   db 1
contadorFact        db 1

;Reserva de memoria
section .bss
caracter            resb 1
numero              resb STRLEN+1
elementoImprimible  resb 50

section .text
global _start:
_start:
    push rbp
    mov rbp, rsp

    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    ;Mostramos mensaje y pedimos entrada al usuario 
    mov rdi, cadIngresaNumero
    call imprimirString

    ;leer digito por digito el termino de la serie
    mov rbx, numero     ;direccion de numero en rbx
    mov r12, 0          ;contador en r12 = 0

leeEntrada:
    mov rax, SYS_read   ;codigo para leer
    mov rdi, STDIN      ;entrada (standard in)
    lea rsi, [caracter] ;direccion de caracter se guarda el valor en caracter
    mov rdx, 1          ;cuantos bytes leeremos
    syscall             
    
    mov al, byte [caracter]  ;mover valor de caracter
    cmp al, LF          ;Si linefeed (enter), entrada terminada
    je entradaTerminada
    
    cmp r12, STRLEN     ;if # digitos(contador) ≥ STRLEN
    jae leeEntrada      ;stop placing in buffer
    
    mov byte [rbx], al  ;numero[i] = caracter(digito)
    inc r12             ;contador++
    inc rbx             ; actualizamos la direccion de numero (siguiente indice)
    
    jmp leeEntrada

entradaTerminada:
    mov byte [rbx], NULL ;agrega NULL al final de numero 
    dec rbx

casteaNumero:
    cmp r12, 2
    je casteaUnidades

    cmp r12, 1
    je casteaDecenas

    cmp r12, 0
    je trianguloDePascal

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

trianguloDePascal:
    lea rsi, [elementoImprimible]
    mov rax, qword[elemento] 
    call imprimeNumero

    mov rax,1
    mov rdi,1
    mov rsi,salto
    mov rdx,2
    syscall
    paraCadaFila:
        mov byte [i], 0
        ;calculamos el valor de factorial_m (m)
        mov rax, qword[fila]
        call factorial
        mov qword[facto_m], rax
        
        calculaValor:
            xor rax, rax
            xor rbx, rbx
            xor rdx, rdx
            
            ;calculamos el valor de factorial_n (n)
            mov rax, qword[i]
            call factorial
            mov qword[facto_n], rax
            
            ;calculamos el valor de multiplicador (m - n)!
            mov rax, qword[fila]
            sub rax, qword[i]
            call factorial
            mov qword[multiplicador], rax
            
            ;calculamos el divisor de la formula  n! * (m - n)!
            mov rax, qword[facto_n]
            mov rbx, qword[multiplicador]
            mul rbx

            ;calculamos el elemento
            mov rbx, rax      ;guardamos nuestro divisor, es decir, n! * (m - n)!
            mov rax, qword[facto_m]
            div rbx            ; en rdx queda el residuo y en rax el resultado
            mov qword[elemento], rax

            ;imprimios el numero
            lea rsi, [elementoImprimible]
            mov rax, qword[elemento] 
            call imprimeNumero

            ;checamos si hay mas elementos que imprimir en la fila
            inc byte[i]         ;i++
            mov al, byte[fila]  ;al = fila
            cmp byte [i], al    ;if i <= fila
            jle calculaValor     ;seguir imprimiendo valores
            
        ;Checamos si aun hay mas filas para imprimir
        mov rax,1
        mov rdi,1
        mov rsi,salto
        mov rdx,2
        syscall

        inc byte [fila]         ;fila = fila + 1
        mov al, [valorNumerico] ;al = *valorNumerico
        cmp [fila], al          ;if fila < valorNumerico
        jl paraCadaFila        ;seguir calculando

final:
    pop rbp
    mov rsp, rbp

    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


;FUNCIONES
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
    ;Contamos los caracteres
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
    ;Imprimimos la cadena
	mov	rax, SYS_write
	mov	rsi, rdi
	mov	rdi, STDOUT
	syscall
    parteTerminada:
	pop	rbx
	pop	rbp
	ret

imprimeNumero:
    push	rbp
	mov	rbp, rsp
	push	rbx

    mov qword[dividendo], rax   ;el parametro rax lo hacemos nuestro dividendo
    
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
      
    mov bh, byte[contador]
    inc bh
    incrementaRsi:
        pop rdx
        mov [rsi], rdx
        dec byte[contador]
        inc rsi
        mov bl, byte[contador]
        cmp bl, 0
        jne  incrementaRsi
    
    mov byte[contador], bh
    mov rax,SYS_write 
    mov rdi,STDOUT
	mov rsi,elementoImprimible
	mov rdx,[contador]
	syscall
    
    mov rax,SYS_write 
    mov rdi,STDOUT
	mov rsi,espacio
	mov rdx,1
	syscall

    
    mov byte[contador], 0 
    pop	rbx
	pop	rbp
    ret

factorial:
    push rbp
	mov	 rbp, rsp
	push rbx

    mov bl, al ;n
    mov rax, 1 ;factorial, es lo que devolveremos
    mov byte [contadorFact], 1 ; cl = i = 1, nuestro contador de ciclo
    mov rcx, 1
    calculaFactorial:
        mul rcx

        inc rcx             ;i++
        inc byte[contadorFact]
        cmp byte [contadorFact], bl        ;if i <= n (rcx <= rbx)
        jle calculaFactorial;calcula otro factorial
    
    pop	rbx
	pop	rbp
    ret