#include <stdio.h>

int main()
{
    int n, segundos, minutos, horas;

    scanf("%d", &n);
    horas = n/(60*60);
    n = n - (horas*60*60);
    minutos = n/60;
    n = n - (minutos*60);
    segundos = n;
    if (horas<10)
        printf("0%d:", horas);
    else
        printf("%d:", horas);
    if (minutos<10)
        printf("0%d:", minutos);
    else
        printf("%d:", minutos);
    if (segundos<10)
        printf("0%d\n", segundos);
    else
        printf("%d\n", segundos);
    return 0;

}