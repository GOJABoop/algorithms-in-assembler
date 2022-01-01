#include <stdio.h>
#include <stdlib.h>

#define TAM_MATRIZ 4
enum{ SUMA_VECTORES=1, PRODUCTO_PUNTO, SUMA_MATRICES, PRODUCTO_MATRICES,
		MATRIZ_INVERSA, SALIR};

/// Funciones en ensamblador
float* sumaVectores4(float*,float*);
float* sumaVectores8(float*,float*);
float* sumaVectores16(float*,float*);
void productoPunto4(float*,float*);
void productoPunto8(float*,float*);
void productoPunto16(float*,float*);
void sumaMatrices(float[TAM_MATRIZ][TAM_MATRIZ],float[TAM_MATRIZ][TAM_MATRIZ]);
void productoMatrices(float[TAM_MATRIZ][TAM_MATRIZ],float[TAM_MATRIZ][TAM_MATRIZ]);
void inversaMatriz();

void imprimirVector(float* resultado, int tam); // En C

int main() {
    int opcion1, opcion2, i, j;
    float* resultado;
    float vector4[4], vector8[8], vector16[16], matriz[TAM_MATRIZ][TAM_MATRIZ];
    float vector4_2[4], vector8_2[8], vector16_2[16], matriz_2[TAM_MATRIZ][TAM_MATRIZ];
    do {
        system("clear");
        printf("Menu principal: \n");
        printf("1. Suma de vectores\n");
        printf("2. Producto punto\n");
        printf("3. Suma de matrices\n");
        printf("4. Producto matricial\n");
        printf("5. Inversa de una matriz\n");
        printf("6. Salir\n");
        printf("   Ingrese una opcion: ");
        scanf("%d", &opcion1);

        switch (opcion1) {
            case 1:
                printf("Suma de vetores:\n\n");
                printf("Ingrese la dimension de los vectores (4, 8, 16): ");
                scanf("%d", &opcion2);

                switch (opcion2){
                    case 4:
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del del vector 1: ", i+1);
                            scanf("%f", &vector4[i]);
                        }
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del vector 2: ", i+1);
                            scanf("%f", &vector4_2[i]);
                        }
                        imprimirVector(sumaVectores4(vector4,vector4_2), 4);
                        break;
                    case 8:
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del del vector 1: ", i+1);
                            scanf("%f", &vector8[i]);
                        }
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del vector 2: ", i+1);
                            scanf("%f", &vector8_2[i]);
                        }
                        imprimirVector(sumaVectores8(vector8,vector8_2), 8);
                        break;
                    case 16:
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del del vector 1: ", i+1);
                            scanf("%f", &vector16[i]);
                        }
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del vector 2: ", i+1);
                            scanf("%f", &vector16_2[i]);
                        }
                        imprimirVector(sumaVectores16(vector16,vector16_2),16);
                        break;
                    default:
                        printf("Opcion no valida\n");
                }
                break;
            case 2:
                printf("Producto punto:\n\n");
                printf("Ingrese la dimension de los vectores (4, 8, 16):  ");
                scanf("%d", &opcion2);

                switch (opcion2){
                    case 4:
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del del vector 1:  ", i+1);
                            scanf("%f", &vector4[i]);
                        }
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del vector 2: ", i+1);
                            scanf("%f", &vector4_2[i]);
                        }
                        productoPunto4(vector4,vector4_2);
                        break;
                    case 8:
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del del vector 1: ", i+1);
                            scanf("%f", &vector8[i]);
                        }
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del vector 2: ", i+1);
                            scanf("%f", &vector8_2[i]);
                        }
                        productoPunto8(vector8,vector8_2);
                        break;
                    case 16:
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del del vector 1 -> ", i+1);
                            scanf("%f", &vector16[i]);
                        }
                        for (i=0; i<opcion2; i++) {
                            printf("Ingrese el valor %d del vector 2 -> ", i+1);
                            scanf("%f", &vector16_2[i]);
                        }
                        productoPunto16(vector16,vector16_2);
                        break;
                    default:
                        printf("Opcion no valida\n");
                }
                break;
            case 3:
                printf("Suma de matrices:\n\n");

                for (i=0; i<TAM_MATRIZ; i++) {
                    for (j=0; j<TAM_MATRIZ; j++) {
                        printf("Ingrese el valor de la matriz 1 en %d, %d: ", i, j);
                        scanf("%f", &matriz[i][j]);
                    }
                }

                for (i=0; i<TAM_MATRIZ; i++) {
                    for (j=0; j<TAM_MATRIZ; j++) {
                        printf("Ingrese el valor de la matriz 2 en %d, %d: ", i, j);
                        scanf("%f", &matriz_2[i][j]);
                    }
                }
			    sumaMatrices(matriz,matriz_2);
                break;
            case 4:
                printf("Producto matricial:\n\n");

                for (i=0; i<TAM_MATRIZ; i++) {
                    for (j=0; j<TAM_MATRIZ; j++) {
                        printf("Ingrese el valor de la matriz 1 en %d, %d: ", i, j);
                        scanf("%f", &matriz[i][j]);
                    }
                }

                for (i=0; i<TAM_MATRIZ; i++) {
                    for (j=0; j<TAM_MATRIZ; j++) {
                        printf("Ingrese el valor de la matriz 2 en %d, %d: ", i, j);
                        scanf("%f", &matriz_2[j][i]);
                    }
                }
				productoMatrices(matriz,matriz_2);
                break;
            case 5:
                printf("Inversa de una matriz:\n\n");

                for (i=0; i<TAM_MATRIZ; i++) {
                    for (j=0; j<TAM_MATRIZ; j++) {
                        printf("Ingrese el valor de la matriz en %d, %d: ", i, j);
                        scanf("%f", &matriz[i][j]);
                    }
                }
				int i, j;
                float determinant = 0;
                printf("\nLa matriz dada es:");
                for(i = 0; i < TAM_MATRIZ; i++){
                    printf("\n");
                    
                    for(j = 0; j < TAM_MATRIZ; j++)
                        printf("%f\t", matriz[i][j]);
                }
                for(i = 0; i < TAM_MATRIZ; i++)
                    determinant = determinant + (matriz[0][i] * (matriz[1][(i+1)%TAM_MATRIZ] * matriz[2][(i+2)%TAM_MATRIZ] - matriz[1][(i+2)%TAM_MATRIZ] * matriz[2][(i+1)%TAM_MATRIZ]));
                
                printf("\n\nDeterminante: %f\n", determinant);
                if (determinant == 0){
                    break;
                }
                printf("\nLa inversa de la matriz es: \n");
                for(i = 0; i < TAM_MATRIZ; i++){
                    for(j = 0; j < TAM_MATRIZ; j++)
                        printf("%.2f\t",((matriz[(j+1)%TAM_MATRIZ][(i+1)%TAM_MATRIZ] * matriz[(j+2)%TAM_MATRIZ][(i+2)%TAM_MATRIZ]) - (matriz[(j+1)%TAM_MATRIZ][(i+2)%TAM_MATRIZ] * matriz[(j+2)%TAM_MATRIZ][(i+1)%TAM_MATRIZ]))/ determinant);
                    
                    printf("\n");
                }
                break;
            case 6:
                printf("Hasta luego =) \n");
                break;
            default:
                printf("Opcion no valida\n");
    }
        getchar();
        getchar();
    } while(opcion1!=SALIR);
    return 0;
}


void imprimirVector(float* resultado, int tam){
		for (int i=0; i < tam; i++){
			printf("%f ",resultado[i]);
		}
		printf("\n");

}
