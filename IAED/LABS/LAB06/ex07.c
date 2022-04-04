#include <stdio.h>

struct Data
{
    int dia;
    int mes;
    int ano;
} data;

int main()
{
    int dia, mes, ano;

    scanf("%d-%d-%d", &data.dia, &data.mes, &data.ano);

    if (data.dia + 1 > 31 && (data.mes == 1 || data.mes == 3 || data.mes == 5 || data.mes == 7 || data.mes == 8 || data.mes == 10 || data.mes == 12))
    {
        dia = 1;
        mes = data.mes + 1;
        ano = data.ano;
    }
    else if (data.dia + 1 > 30 && (data.mes == 4 || data.mes == 6 || data.mes == 9 || data.mes == 11))
    {
        dia = 1;
        mes = data.mes + 1;
        ano = data.ano;
    }
    else if (data.dia + 1 > 28 && data.mes == 2 && data.ano%4 != 0)
    {
        dia = 1;
        mes = data.mes + 1;
        ano = data.ano;
    }
    else if (data.dia + 1 > 29 && data.mes == 2 && data.ano%4 == 0)
    {
        dia = 1;
        mes = data.mes + 1;
        ano = data.ano;
    }
    else
    {
        dia = data.dia + 1;
        mes = data.mes;
        ano = data.ano;
    }

    if (mes > 12)
    {
        dia = 1;
        mes = 1;
        ano = data.ano + 1;
    }

    printf("%02d-%02d-%d\n", dia, mes, ano);
    return 0;
}