#include <stdio.h>
#include <stdlib.h>

extern void multiplicaComplejos(float *n_1, float *n_2);

int main(){
    float n_1[4];
    float n_2[4];
    float parteReal, parteImaginaria;

    for(int i = 0; i < 2; i++){
        printf("Numero %d\n", i+1);
        printf("Parte real: ");
        scanf("%f", &parteReal);
        printf("Parte imaginaria: ");
        scanf("%f", &parteImaginaria);
        if(i == 0){
            n_1[0] = parteReal;
            n_1[1] = parteImaginaria;
            n_1[2] = 0;
            n_1[3] = 0;
        }
        else{
            n_2[0] = parteReal;
            n_2[1] = parteImaginaria;
            n_2[2] = 0;
            n_2[3] = 0;
        }
    }
    printf("\nResultado: ");
    multiplicaComplejos(n_1,n_2);
    return 0;
}
