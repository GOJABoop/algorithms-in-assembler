BITS 64

;Definicion de constantes
LF		       	equ	10
NULL		 	equ	0
STDOUT		    equ	1
SYS_exit	    equ	60
SYS_write     	equ 1
EXIT_SUCCESS  	equ 0

section .data align=16

	frmt2:	db	"Dato:	%lf",LF,NULL
	frmtM:	db	"%f		%f		%f		%f",LF,NULL
	
section .bss align=16
	v1:	resq			16
	v2:	resq			16
	salida:		resq	16
	salida1:	resq	16
	salida2:	resq	16
	salida3:	resq	16
	salida4:	resq	16
	respaldo1:	resq	16
	respaldo2:	resq	16
	respaldo3:	resq	16
	respaldo4:	resq	16
	respaldo5:	resq	16
	respaldo6:	resq	16
	respaldo7:	resq	16
	respaldo8:	resq	16
	aux1:		resq	16
	aux2:		resq	16
	aux3:		resq	16
	aux4:		resq	16
	resultado 	resq 	32
	
section .text 
global sumaVectores4
extern printf

sumaVectores4:
	push rbp
	mov rbp,rsp
	
	sub rsp,128
	;cargar vectores
	mov rbx,salida
	movaps xmm0,[rdi]
	movaps xmm1,[rsi]
	;suma vectores
	addps xmm0,xmm1
	
	
	;imprimir
	movaps [rel salida],xmm0
	mov rax, salida
	
	mov rsp,rbp
	pop rbp
	
	ret
	
global sumaVectores8
sumaVectores8:
	push rbp
	mov rbp,rsp
	sub rsp,128
	
	;cargar vectores
	
	mov rbx,salida
	;vector1
	movaps xmm0,[rdi]
	movaps xmm1,[rdi+16]
	;vector2
	movaps xmm2,[rsi]
	movaps xmm3,[rsi+16]
	;suma vectores
	addps xmm0,xmm2
	addps xmm1,xmm3
	
	;imprimir
	movaps [rel resultado],xmm0
	movaps [rel resultado+16],xmm1
	
	mov rax, resultado
	
	mov rsp,rbp
	pop rbp
	
	ret

global sumaVectores16

sumaVectores16:
	push rbp
	mov rbp,rsp
	sub rsp,128
	
	mov rbx,salida
	
	movaps xmm0, [rdi]
	movaps xmm1, [rsi]
	movaps xmm2, [rdi+16]
	movaps xmm3, [rsi+16]
	movaps xmm4, [rdi+32]
	movaps xmm5, [rsi+32]
	movaps xmm6, [rdi+48]
	movaps xmm7, [rsi+48]
	
	addps xmm0,xmm1
	addps xmm2,xmm3
	addps xmm4,xmm5
	addps xmm6,xmm7
	
	movaps [rel resultado],xmm0
	movaps [rel resultado+16],xmm2
	movaps [rel resultado+32],xmm4
	movaps [rel resultado+48],xmm6
	
	mov rax, resultado
	
	mov rsp,rbp
	pop rbp
	
	ret
	
global productoPunto4
productoPunto4:
	push rbp
	mov rbp, rsp
	sub rsp, 128
	
	;carga
	movaps xmm0,[rdi]

	movaps xmm1,[rsi]
	;multilica
	mulps xmm0, xmm1

	movss xmm1, xmm0
	haddps	xmm0, xmm1 ;suma parcial half add single pression 
	movaps [rel salida], xmm0
	

	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]

	sub rsp,16
	cvtss2sd xmm0, xmm0
	mov rdi, frmt2
	mov rax, 1
	call printf WRT ..plt
	add rsp,16
	
	mov rsp, rbp
	pop rbp
	
	ret

global productoPunto8
productoPunto8:
	push rbp
	mov rbp, rsp
	sub rsp, 128
	
	;carga
	movaps xmm0,[rdi]
	movaps xmm1,[rdi+16]

	movaps xmm2,[rsi]
	movaps xmm3,[rsi+16]
	;multilica
	mulps xmm0, xmm2
	mulps xmm1, xmm3

	movss xmm2, xmm0
	movss xmm3, xmm1
	haddps	xmm0, xmm2 ;suma parcial half add single pression 
	haddps	xmm1, xmm3 ;suma parcial half add single pression 
	movaps [rel salida], xmm0
	movaps [rel salida2], xmm1
	

	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida2]
	addss xmm0,[rel salida2+4]
	

	sub rsp,16
	cvtss2sd xmm0, xmm0
	mov rdi, frmt2
	mov rax, 1
	call printf WRT ..plt
	add rsp,16
	
	mov rsp, rbp
	pop rbp
	
	ret
global productoPunto16
productoPunto16:
	push rbp
	mov rbp, rsp
	sub rsp, 128
	
	;carga
	movaps xmm0,[rdi]
	movaps xmm1,[rdi+16]
	movaps xmm2,[rdi+32]
	movaps xmm3,[rdi+48]

	movaps xmm4,[rsi]
	movaps xmm5,[rsi+16]
	movaps xmm6,[rsi+32]
	movaps xmm7,[rsi+48]
	;multilica
	mulps xmm0, xmm4
	mulps xmm1, xmm5
	mulps xmm2, xmm6
	mulps xmm3, xmm7
	
	movss xmm4, xmm0
	movss xmm5, xmm1
	movss xmm6, xmm2
	movss xmm7, xmm3
	haddps	xmm0, xmm4 ;suma parcial half add single pression 
	haddps	xmm1, xmm5 ;suma parcial half add single pression 
	haddps	xmm2, xmm6 ;suma parcial half add single pression 
	haddps	xmm3, xmm7 ;suma parcial half add single pression 
	movaps [rel salida], xmm0
	movaps [rel salida2], xmm1
	movaps [rel salida3], xmm2
	movaps [rel salida4], xmm3
	

	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida2]
	addss xmm0,[rel salida2+4]
	addss xmm0,[rel salida3]
	addss xmm0,[rel salida3+4]
	addss xmm0,[rel salida4]
	addss xmm0,[rel salida4+4]
	

	sub rsp,16
	cvtss2sd xmm0, xmm0
	mov rdi, frmt2
	mov rax, 1
	call printf WRT ..plt
	add rsp,16
	
	mov rsp, rbp
	pop rbp
	
	ret

global sumaMatrices
sumaMatrices:
	push rbp
	mov rbp, rsp
	sub rsp, 128
	
	;carga
	movaps xmm0,[rdi]
	movaps xmm1,[rdi+16]
	movaps xmm2,[rdi+32]
	movaps xmm3,[rdi+48]

	movaps xmm4,[rsi]
	movaps xmm5,[rsi+16]
	movaps xmm6,[rsi+32]
	movaps xmm7,[rsi+48]
	
	addps xmm0,xmm4
	addps xmm1,xmm5
	addps xmm2,xmm6
	addps xmm3,xmm7
	
	movaps [rel salida],xmm0
	movaps [rel salida2],xmm1
	movaps [rel salida3],xmm2
	movaps [rel salida4],xmm3
	
	sub rsp,16
	movss xmm0,[rel salida]
	movss xmm1,[rel (salida+4)]
	movss xmm2,[rel (salida+8)]
	movss xmm3,[rel (salida+12)]
	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16

	sub rsp,16
	movss xmm0,[rel salida2]
	movss xmm1,[rel (salida2+4)]
	movss xmm2,[rel (salida2+8)]
	movss xmm3,[rel (salida2+12)]
	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16
	
	sub rsp,16
	movss xmm0,[rel salida3]
	movss xmm1,[rel (salida3+4)]
	movss xmm2,[rel (salida3+8)]
	movss xmm3,[rel (salida3+12)]
	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16
	
	sub rsp,16
	movss xmm0,[rel salida4]
	movss xmm1,[rel (salida4+4)]
	movss xmm2,[rel (salida4+8)]
	movss xmm3,[rel (salida4+12)]
	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16
	
	mov rsp,rbp
	pop rbp
	
	ret
	
global productoMatrices
productoMatrices:
	push rbp
	mov rbp, rsp
	sub rsp, 128
	
	;carga matriz 1
	movaps xmm0,[rdi]
	movaps xmm1,[rdi+16]
	movaps xmm2,[rdi+32]
	movaps xmm3,[rdi+48]
	;repaldamos la matriz 1
	movaps [rel respaldo1],xmm0
	movaps [rel respaldo2],xmm1
	movaps [rel respaldo3],xmm2
	movaps [rel respaldo4],xmm3
	
	;cargar matriz 2
	movaps xmm4,[rsi]
	movaps xmm5,[rsi+16]
	movaps xmm6,[rsi+32]
	movaps xmm7,[rsi+48]
	;respaldo matriz 2
	movaps [rel respaldo5],xmm4
	movaps [rel respaldo6],xmm5
	movaps [rel respaldo7],xmm6
	movaps [rel respaldo8],xmm7
	;Primer termino primer fila

	movaps [rel aux1],xmm0
	movaps [rel aux2],xmm4
	mulps xmm0, xmm4
	movss xmm4, xmm0
	movaps [rel salida], xmm0
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	
	
	movaps	[rel salida1],xmm0
	movaps xmm0, [rel aux1]
	movaps xmm4, [rel aux2]
	
	;segundo termino
	
	movaps [rel aux1],xmm0
	movaps [rel aux2],xmm5
	mulps xmm0, xmm5
	movss xmm5, xmm0
	movaps [rel salida], xmm0
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida2],xmm0

	movaps xmm0, [rel aux1]
	movaps xmm5, [rel aux2]
	
	;tercer termino
	
	movaps [rel aux1],xmm0
	movaps [rel aux2],xmm6
	mulps xmm0, xmm6
	movss xmm6, xmm0
	movaps [rel salida], xmm0
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida3],xmm0

	movaps xmm0, [rel aux1]
	movaps xmm6, [rel aux2]
	
	;cuarto termino
	movaps [rel aux1],xmm0
	movaps [rel aux2],xmm7
	mulps xmm0, xmm7
	movss xmm7, xmm0
	movaps [rel salida], xmm0
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida4],xmm0

	movaps xmm0, [rel aux1]
	movaps xmm7, [rel aux2]
	
	;impresion
	sub rsp,16
	movss xmm0,[rel salida1]
	movss xmm1,[rel salida2]
	movss xmm2,[rel salida3]
	movss xmm3,[rel salida4]

	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16
	
	movaps xmm0,[rel respaldo1]
	movaps xmm1,[rel respaldo2]
	movaps xmm2,[rel respaldo3]
	movaps xmm3,[rel respaldo4]
	movaps xmm4,[rel respaldo5]
	movaps xmm5,[rel respaldo6]
	movaps xmm6,[rel respaldo7]
	movaps xmm7,[rel respaldo8]
	
	;segunda fila
	
	;Primer termino segundo fila

	movaps [rel aux1],xmm1
	movaps [rel aux2],xmm4
	mulps xmm1, xmm4
	movss xmm4, xmm1
	movaps [rel salida], xmm1
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida1],xmm0

	movaps xmm1, [rel aux1]
	movaps xmm4, [rel aux2]
	
	;segundo termino
	
	movaps [rel aux1],xmm1
	movaps [rel aux2],xmm5
	mulps xmm1, xmm5
	movss xmm5, xmm1
	movaps [rel salida], xmm1
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida2],xmm0

	movaps xmm1, [rel aux1]
	movaps xmm5, [rel aux2]
	
	;tercer termino
	
	movaps [rel aux1],xmm1
	movaps [rel aux2],xmm6
	mulps xmm1, xmm6
	movss xmm6, xmm1
	movaps [rel salida], xmm1
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida3],xmm0

	movaps xmm1, [rel aux1]
	movaps xmm6, [rel aux2]
	
	;cuarto termino
	movaps [rel aux1],xmm1
	movaps [rel aux2],xmm7
	mulps xmm1, xmm7
	movss xmm7, xmm1
	movaps [rel salida], xmm1
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida4],xmm0

	movaps xmm1, [rel aux1]
	movaps xmm7, [rel aux2]
	
	;impresion
	sub rsp,16
	movss xmm0,[rel salida1]
	movss xmm1,[rel salida2]
	movss xmm2,[rel salida3]
	movss xmm3,[rel salida4]

	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16
	
	movaps xmm0,[rel respaldo1]
	movaps xmm1,[rel respaldo2]
	movaps xmm2,[rel respaldo3]
	movaps xmm3,[rel respaldo4]
	movaps xmm4,[rel respaldo5]
	movaps xmm5,[rel respaldo6]
	movaps xmm6,[rel respaldo7]
	movaps xmm7,[rel respaldo8]
	;Tercera fila
	
	;Primer termino tercera fila

	movaps [rel aux1],xmm2
	movaps [rel aux2],xmm4
	mulps xmm2, xmm4
	movss xmm4, xmm2
	movaps [rel salida], xmm2
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida1],xmm0

	movaps xmm2, [rel aux1]
	movaps xmm4, [rel aux2]
	
	;segundo termino
	
	movaps [rel aux1],xmm2
	movaps [rel aux2],xmm5
	mulps xmm2, xmm5
	movss xmm5, xmm2
	movaps [rel salida], xmm2
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida2],xmm0

	movaps xmm2, [rel aux1]
	movaps xmm5, [rel aux2]
	
	;tercer termino
	
	movaps [rel aux1],xmm2
	movaps [rel aux2],xmm6
	mulps xmm2, xmm6
	movss xmm6, xmm2
	movaps [rel salida], xmm2
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida3],xmm0

	movaps xmm2, [rel aux1]
	movaps xmm6, [rel aux2]
	
	;cuarto termino
	movaps [rel aux1],xmm2
	movaps [rel aux2],xmm7
	mulps xmm2, xmm7
	movss xmm7, xmm2
	movaps [rel salida], xmm2
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida4],xmm0

	movaps xmm2, [rel aux1]
	movaps xmm7, [rel aux2]
	
	;impresion
	sub rsp,16
	movss xmm0,[rel salida1]
	movss xmm1,[rel salida2]
	movss xmm2,[rel salida3]
	movss xmm3,[rel salida4]

	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16
	
	movaps xmm0,[rel respaldo1]
	movaps xmm1,[rel respaldo2]
	movaps xmm2,[rel respaldo3]
	movaps xmm3,[rel respaldo4]
	movaps xmm4,[rel respaldo5]
	movaps xmm5,[rel respaldo6]
	movaps xmm6,[rel respaldo7]
	movaps xmm7,[rel respaldo8]
	;Cuarta fila
	
	;Primer termino cuarta fila

	movaps [rel aux1],xmm3
	movaps [rel aux2],xmm4
	mulps xmm3, xmm4
	movss xmm4, xmm3
	movaps [rel salida], xmm3
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida1],xmm0

	movaps xmm3, [rel aux1]
	movaps xmm4, [rel aux2]
	
	;segundo termino
	
	movaps [rel aux1],xmm3
	movaps [rel aux2],xmm5
	mulps xmm3, xmm5
	movss xmm5, xmm3
	movaps [rel salida], xmm3
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida2],xmm0

	movaps xmm3, [rel aux1]
	movaps xmm5, [rel aux2]
	
	;tercer termino
	
	movaps [rel aux1],xmm3
	movaps [rel aux2],xmm6
	mulps xmm3, xmm6
	movss xmm6, xmm3
	movaps [rel salida], xmm3
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida3],xmm0

	movaps xmm3, [rel aux1]
	movaps xmm6, [rel aux2]
	
	;cuarto termino
	movaps [rel aux1],xmm3
	movaps [rel aux2],xmm7
	mulps xmm3, xmm7
	movss xmm7, xmm3
	movaps [rel salida], xmm3
	movss xmm0,[rel salida]
	addss xmm0,[rel salida+4]
	addss xmm0,[rel salida+8]
	addss xmm0,[rel salida+12]
	movaps	[rel salida4],xmm0

	movaps xmm3, [rel aux1]
	movaps xmm7, [rel aux2]
	
	;impresion
	sub rsp,16
	movss xmm0,[rel salida1]
	movss xmm1,[rel salida2]
	movss xmm2,[rel salida3]
	movss xmm3,[rel salida4]

	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	mov rdi,frmtM
	mov rax,4
	call printf WRT ..plt
	add rsp,16	
	
	mov rsp,rbp
	pop rbp
	
	ret
