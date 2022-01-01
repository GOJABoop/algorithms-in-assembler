#include <stdio.h>
#include <stdlib.h>
#include <locale.h>

extern void terceraLeyDeKepler(double semieje);

int main(){
    setlocale(LC_CTYPE,"spanish");
    double semieje;
    printf("Semieje mayor (UA): ");
    scanf("%lf",&semieje);
    printf("Período orbital: ");
    terceraLeyDeKepler(semieje);
    return 0;
}
