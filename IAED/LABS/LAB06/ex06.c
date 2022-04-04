#include <stdio.h>

struct Data
{
    int dia;
    int mes;
    int ano;
} data1, data2;

int main()
{
    int flag=0;

    scanf("%d-%d-%d %d-%d-%d", &data1.dia, &data1.mes, &data1.ano, &data2.dia, &data2.mes, &data2.ano);

    if (data1.ano > data2.ano)
    {
        flag = 1;
    }
    else if (data1.ano == data2.ano)
    {
        if(data1.mes > data2.mes)
        {
            flag = 1;
        }
        else if (data1.mes == data2.mes)
        {
            if (data1.dia > data2.dia)
            {
                flag = 1;
            }
        }
    }

    if(flag == 1)
    {
        printf("%02d-%02d-%d %02d-%02d-%d\n", data2.dia, data2.mes, data2.ano, data1.dia, data1.mes, data1.ano);
    }
    else
    {
        printf("%02d-%02d-%d %02d-%02d-%d\n", data1.dia, data1.mes, data1.ano, data2.dia, data2.mes, data2.ano);
    }
    return 0;
}