#include <stdio.h>

struct Hora
{
    int hora;
    int minutos;
} hora1, hora2;

int main()
{
    int hora=0, minutos;

    scanf("%d:%d %d:%d", &hora1.hora, &hora1.minutos, &hora2.hora, &hora2.minutos);

    if (hora1.minutos + hora2.minutos > 59)
    {
        minutos = hora1.minutos + hora2.minutos - 60;
        hora = hora1.hora + hora2.hora + 1;
    }
    else
    {
        minutos = hora1.minutos + hora2.minutos;
        hora = hora1.hora + hora2.hora;
    }

    printf("%02d:%02d\n", hora, minutos);
    return 0;
}