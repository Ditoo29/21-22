#include <stdio.h>

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
