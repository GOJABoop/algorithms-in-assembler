%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void escribeArchivo(int valor);
void regInmediato(int valor, const char* texto, size_t numElementos);
void declaracionFuncion(const char *ptr, int indice);
void declaracionVariable(const char *ptr);
void encuentraIdentificador(int valor, const char *texto, size_t numElementos);

typedef struct{
	char *nombre;
	char *direccion;
	char *valor;
}Variable;

int cuentaVariables; //se inicializa en cero variable global
Variable vars[3];//usar lista ligada o alguna otra estructura de datos para mas casos
%}

DIGIT [0-9]
ET [a-z][a0-z9]*

%%
[s][e][c][t][i][o][n]" "[.][d][a][t][a] {printf("desensamblado section .data");}
[s][e][c][t][i][o][n]" "[.][t][e][x][t]	{printf("desensamblado section .text");}
{ET}{1}[:]" "[d][b]" "["]{ET}{1}" "{ET}{1}["]","{DIGIT}{1,2}","{DIGIT}{1} {declaracionVariable(yytext);}
[p][u][s][h]" "[r][b][p]    {escribeArchivo(0x55);}
[m][o][v]" "[r][b][p]","[r][s][p]	{escribeArchivo(0x4889E5);}
[m][o][v]" "[r][a][x]","{DIGIT}{1,2}	{regInmediato(0xB8,yytext,2);}
[m][o][v]" "[r][d][i]","{DIGIT}{1,2}	{regInmediato(0xBF,yytext,2);}
[m][o][v]" "[r][s][i]","{ET}{1}	{encuentraIdentificador(0x48BE,yytext,4);}
[m][o][v]" "[r][d][x]","{DIGIT}{1,2}	{regInmediato(0xBA,yytext,2);}
[s][y][s][c][a][l][l]	{escribeArchivo(0x0F05);}
[a][d][d]" "[r][a][x]","{DIGIT}{1,2}	{regInmediato(0x4883C0,yytext,6);}
[m][o][v]" "[r][s][p]","[r][b][p]	{escribeArchivo(0x4889EC);}
[p][o][p]" "[r][b][p]	{escribeArchivo(0x5D);}
[g][l][o][b][a][l]" "{ET}{1}	{declaracionFuncion(yytext,7);}
%%

void escribeArchivo(int valor){
	FILE *archivo;
	char *nombreArchivo="traductor.o";
	archivo=fopen(nombreArchivo,"ab");
	printf("%X",valor);
	if(archivo!=NULL){
		fwrite(&valor,sizeof(valor),1,archivo);
		fflush(archivo);
		fclose(archivo);
	}
}

void regInmediato(int valor, const char *texto, size_t numElementos){
	int i,contador,valorDecimal,caracteresAExtraer;
	caracteresAExtraer = strlen(texto)-8;
	char aux[caracteresAExtraer];
	char valorHex[caracteresAExtraer];
	char valorFinal[numElementos+caracteresAExtraer];
	for(i=8,contador=0;i<strlen(texto);i++){
		aux[contador]=texto[i];
		contador++;
	}
	valorDecimal = atoi(aux);
	if(valorDecimal>15){
		sprintf(valorHex,"%X",valorDecimal);
	}else{
		sprintf(valorHex,"0%X",valorDecimal);
	}
	sprintf(valorFinal,"%X",valor);
	strcat(valorFinal,valorHex);
	printf("%X%s",valor,valorHex);
	sscanf(valorFinal,"%X",&valor);
	FILE *archivo;
	char *nombreArchivo="traductor.o";
	archivo=fopen(nombreArchivo,"ab");
	if(archivo!=NULL){
		fwrite(&valor,sizeof(valor),1,archivo);
		fflush(archivo);
		fclose(archivo);
	}
}

void declaracionFuncion(const char *ptr, int indice){
	printf("0000000000000000 <inicio>");
}

void declaracionVariable(const char *ptr){
	int i=0,longitudNombre;
	while(ptr[i++]!=':')
	longitudNombre=i+1;
	char nombre[longitudNombre];
	for(i=0;i<longitudNombre;i++){
		nombre[i]=ptr[i];	
	}
	vars[cuentaVariables].nombre=nombre;
	if(cuentaVariables>1){
		vars[cuentaVariables].direccion=vars[cuentaVariables-1].direccion;
	}else{
		vars[0].direccion="0000000000000000";
	}
	//buscar por cada una su valor
	vars[cuentaVariables].valor="686F6C61206D756E646F0A00";
	printf("%s",vars[cuentaVariables].valor);
	printf("\nPosicion en memoria\nx%s",vars[cuentaVariables].direccion);
	cuentaVariables++;
}

void encuentraIdentificador(int valor, const char *texto, size_t numElementos){
	int i=8,j, longitudNombre;
	longitudNombre=i+1;
	char nombre[longitudNombre];
	char val[longitudNombre+4];
	for(i=8, j=0;i<longitudNombre;i++,j++){
		nombre[j]=texto[i];
	}
	for(i=0;i<cuentaVariables;i++){
		if(strcmp(nombre,vars[i].nombre)==0){
			break;
		}
	}
	sprintf(val,"%X",valor);
	strcat(val,vars[0].direccion);
	printf("%X%s",valor,vars[0].direccion);
	sscanf(val,"%X",&valor);
	FILE *archivo;
	char *nombreArchivo="traductor.o";
	archivo=fopen(nombreArchivo,"ab");
	if(archivo!=NULL){
		fwrite(&valor,sizeof(valor),1,archivo);
		fflush(archivo);
		fclose(archivo);
	}
}

int main(){
	FILE *archivo;
	archivo=fopen("traductor.o","wb");
	yyin=fopen("prueba.s","r");
	yylex();
	printf("\nTerminado y guardado en 'traductor.o'\n");
	return 0;
}
