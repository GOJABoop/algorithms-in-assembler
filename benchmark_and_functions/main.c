#include <stdlib.h>
#include <stdio.h>
#include "functions.h"

int main(){
    double x, asw;
    x = 0.1;
    printf("Benchmarks\n");
    for(int i = 0; i < 10; i++){
        asw = squarePow(logarithm(arctan(tangent(arccos(cosine(arcsin(sine(x))))))));
        printf("#%d: %f \n",i+1,asw);
        x += 0.1;
    }
    return 0;
}