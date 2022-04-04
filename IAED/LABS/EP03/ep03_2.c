#include <stdio.h>
#include <string.h>

#define MAXNOME 51
#define MAXCIDADE 500
#define MAXPAIS 200

typedef struct 
{
    char nome[MAXNOME];
    int populacao;
    double latitude;
    double longitude;
}Cidade;

typedef struct 
{
    char nome[MAXNOME];
    Cidade cidade[MAXCIDADE];
    int cidades;
}Pais;

Pais onu[MAXPAIS];

/*Actual Exercicio*/

char* pais(Pais p[], int max)
{
    int i,j;
    int max_p=0;
    char maior_p[MAXNOME];

    for (i=0; i<max; i++)
    {
        for (j=0; j<p[i].cidades; j++)
        {
            if(p[i].cidade[j].populacao > max_p)
            {
                strcpy(maior_p, p[i].nome);
                max_p = p[i].cidade[j].populacao;
            }
        }
    }
    return maior_p;
}