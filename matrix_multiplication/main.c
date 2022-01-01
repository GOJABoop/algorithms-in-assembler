#include <stdio.h>
#include <stdlib.h>

typedef struct estructura{
    float fila_1[4];
    float fila_2[4];
    float fila_3[4];
    float fila_4[4];
}matriz;

extern matriz *multiplicacionMatriz(matriz *a, matriz *b);

void imprimeMatriz(matriz* m){
    printf("[%.2f] [%.2f] [%.2f] [%.2f] \n",m->fila_1[0], m->fila_1[1],m->fila_1[2],m->fila_1[3]);
    printf("[%.2f] [%.2f] [%.2f] [%.2f] \n",m->fila_2[0], m->fila_2[1],m->fila_2[2],m->fila_2[3]);
    printf("[%.2f] [%.2f] [%.2f] [%.2f] \n",m->fila_3[0], m->fila_3[1],m->fila_3[2],m->fila_3[3]);
    printf("[%.2f] [%.2f] [%.2f] [%.2f]\n",m->fila_4[0], m->fila_4[1],m->fila_4[2],m->fila_4[3]);
}

int main(){
    matriz matriz_a;
    matriz matriz_b;
    matriz *matriz_c;

    printf("\nMatriz A\n");
    for(int i = 0; i < 4; i++){
        printf("Fila [%d][1]: ", i+1);
        scanf("%f", &matriz_a.fila_1[i]);
        printf("Fila [%d][2]: ", i+1);
        scanf("%f", &matriz_a.fila_2[i]);
        printf("Fila [%d][3]: ", i+1);
        scanf("%f", &matriz_a.fila_3[i]);
        printf("Fila [%d][4]: ", i+1);
        scanf("%f", &matriz_a.fila_4[i]);
    }
    printf("\nMatriz B (transpuesta)\n");
    for(int i = 0; i < 4; i++){
        printf("Columna [%d][1]: ", i+1);
        scanf("%f", &matriz_b.fila_1[i]);
        printf("Columna [%d][2]: ", i+1);
        scanf("%f", &matriz_b.fila_2[i]);
        printf("Columna [%d][3]: ", i+1);
        scanf("%f", &matriz_b.fila_3[i]);
        printf("Columna [%d][4]: ", i+1);
        scanf("%f", &matriz_b.fila_4[i]);
    }
    printf("\nMATRIZ A\n");
    imprimeMatriz(&matriz_a);
    printf("\nMATRIZ B\n");
    imprimeMatriz(&matriz_b);

    matriz_c = multiplicacionMatriz(&matriz_a, &matriz_b);
    printf("\nMatriz Resultado (transpuesta)\n");
    imprimeMatriz(matriz_c);
    return 0;
}
