/* Diogo Pinto | 103259 |  Projeto 2 IAED | 2021/22 | PARTE 2*/

/* Definição das bibliotecas a utilizar neste projeto */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "defs.h"

extern int count_aeroportos;
extern int count_voos;
extern char buffer_id[][DIM_ID];
extern char buffer_codigo[][DIM_CODIGO_MAX];
extern struct Aeroporto aeroportos[];
extern struct Aeroporto temp;
extern struct Voos voos[];
extern struct Voos temp_v;
extern struct Voos v_sort[];
extern struct Voos data_atual;

/* int hash(char *codigo_reserva)
Esta função recebe um ponteiro para um código de reserva como argumento. 
Tem como objetivo designar um índice ao código em questão na hashtable.*/

int hash(char *codigo_reserva)
{
    int h, a = 31415, b = 27183;

    for (h = 0; *codigo_reserva != '\0'; codigo_reserva++, a = a*b % 
    (DIM_TAB-1))
        h = (a*h + *codigo_reserva) % DIM_TAB;

    return h;
}

/* void init_hash(Reservas *hash_table[])
Esta função recebe um ponteiro para uma hash table como argumento. 
Tem como objetivo inicializar todos os índices da hashtable a NULL.*/

void init_hash(Reservas *hash_table[])
{
    int i;
    for(i=0; i<DIM_TAB; i++){
        hash_table[i] = NULL;
    }
}

/* void adiciona_hash(Reservas *r, Reservas *hash_table[])
Esta função recebe um ponteiro para uma hash table e um ponteiro para reserva
como argumento. Tem como objetivo adicionar a reserva à hashtable.*/

void adiciona_hash(Reservas *r, Reservas *hash_table[])
{
    int i;

    i = hash(r->c_reserva);
    r->prox = hash_table[i];
    hash_table[i] = r;
}

/* Reservas *procura_hash()
Esta função recebe um ponteiro para uma hash table e um ponteiro para um 
código de reserva como argumento. Tem como objetivo procurar a reserva 
correspondente ao código recebido na hashtable.*/

Reservas *procura_hash(char *codigo_reserva, Reservas *hash_table[])
{
    int i = hash(codigo_reserva);
    Reservas *temp = hash_table[i];

    while (temp != NULL && strcmp(temp->c_reserva, codigo_reserva) != 0){
        temp = temp->prox;
    }
    return temp;
}

/* void elimina_hash(char *codigo_reserva, Reservas *hash_table[])
Esta função recebe um ponteiro para uma hash table e um ponteiro para um 
código de reserva como argumento. Tem como objetivo eliminar a reserva 
correspondente ao código recebido da hashtable.*/

void elimina_hash(char *codigo_reserva, Reservas *hash_table[])
{
    int i = hash(codigo_reserva);
    Reservas *temp = hash_table[i];
    Reservas *prev = NULL;

    while (temp != NULL && strcmp(temp->c_reserva, codigo_reserva) != 0){
        prev = temp;
        temp = temp->prox;
    }
    if(prev == NULL){
        hash_table[i] = temp->prox;
    }else{
        prev->prox = temp->prox;
    }
}

/* void adiciona_reserva(char codigo_voo[], int dia, int mes, int ano, Reservas *hash_table[])
Esta função recebe um código de voo, dia, mês ano e por fim um ponteiro para 
uma hash table como argumentos. Tem como objetivo apenas criar uma reserva num
determinado voo após acionado o comando "r". Esta criação é somente feita após 
se verificar os erros adjacentes.*/

void adiciona_reserva(char codigo_voo[], int dia, int mes, int ano, Reservas *hash_table[])
{
    char codigo_reserva[MAX_CAR];
    int passageiros;
    int i, len, flag = 0, buffer=-1;
    Reservas *novo = malloc(sizeof(Reservas));
    if (novo == NULL){
        printf("No memory.\n");
        exit(0);
    }

    scanf("%s %d", codigo_reserva, &passageiros);
    len = strlen(codigo_reserva);
    if (len<10){
        printf("invalid reservation code\n");
        free(novo);
        return;
    }
    for (i=0; i<len; i++){
        if(!((codigo_reserva[i]>='A' && codigo_reserva[i]<='Z') || 
        (codigo_reserva[i]>= '0' && codigo_reserva[i]<= '9'))){
            printf("invalid reservation code\n");
            free(novo);
            return;
        }
    }
    for(i=0; i<count_voos; i++)
    {
        if(strcmp(voos[i].codigo, codigo_voo)==0 && voos[i].dia==dia && 
        voos[i].mes==mes && voos[i].ano==ano){
            flag = 1;
            break;
        }
    }
    if(flag == 0){
        printf("%s: flight does not exist\n", codigo_voo);
        free(novo);
        return;
    }
    if(procura_hash(codigo_reserva, hash_table) != NULL){
        printf("%s: flight reservation already used\n", codigo_reserva);
        free(novo);
        return;
    }

    for(i=0; i<count_voos; i++){
        if(strcmp(voos[i].codigo, codigo_voo)==0 && voos[i].dia==dia && 
        voos[i].mes==mes && voos[i].ano==ano){
            if (passageiros + voos[i].passageiros > voos[i].capacidade){
                printf("too many reservations\n");
                free(novo);
                return;
            }
            buffer = i;        
        }
    }
    if (ano<ANO_MIN || ano>ANO_MAX){
        printf("invalid date\n");
        free(novo);
        return;
    }else if (ano > data_atual.ano && mes > data_atual.mes){
        printf("invalid date\n");
        free(novo);
        return;
    }else if (ano > data_atual.ano && mes == data_atual.mes && dia > 
    data_atual.dia){
        printf("invalid date\n");
        free(novo);
        return;
    }else if (ano < data_atual.ano){
        printf("invalid date\n");
        free(novo);
        return;
    }else if (ano == data_atual.ano && mes < data_atual.mes){
        printf("invalid date\n");
        free(novo);
        return;
    }else if (ano == data_atual.ano && mes == data_atual.mes && dia < 
    data_atual.dia){
        printf("invalid date\n");
        free(novo);
        return;
    }
    if(passageiros <= 0){
        printf("invalid passenger number\n");
        free(novo);
        return;
    }    

    voos[buffer].passageiros += passageiros;
    voos[buffer].reservas = realloc(voos[buffer].reservas, sizeof(Reservas*) * (voos[buffer].count_reservas + 1));
    if (voos[buffer].reservas == NULL && voos[buffer].count_reservas != 0){
        printf("No memory.\n");
        exit(0);
    }
    novo->c_voo = malloc(sizeof(char) * (strlen(codigo_voo)+1));
    if (novo->c_voo == NULL){
        printf("No memory.\n");
        exit(0);
    }
    novo->c_reserva = malloc(sizeof(char) * (strlen(codigo_reserva)+1));
    if (novo->c_reserva == NULL){
        printf("No memory.\n");
        exit(0);
    }

    voos[buffer].reservas[voos[buffer].count_reservas] = novo;
    strcpy(voos[buffer].reservas[voos[buffer].count_reservas]->c_voo, codigo_voo);
    strcpy(voos[buffer].reservas[voos[buffer].count_reservas]->c_reserva, codigo_reserva);
    voos[buffer].reservas[voos[buffer].count_reservas]->dia = dia;
    voos[buffer].reservas[voos[buffer].count_reservas]->mes = mes;
    voos[buffer].reservas[voos[buffer].count_reservas]->ano = ano;
    voos[buffer].reservas[voos[buffer].count_reservas]->passageiros = passageiros;    
    adiciona_hash(voos[buffer].reservas[voos[buffer].count_reservas], hash_table);

    voos[buffer].count_reservas++;
    return;
}

/* void ordenar_reservas(int buffer)
Esta função recebe um buffer(índice do voo ao qual correspondem as reservas) 
como argumento. Tem como objetivo ordenar as reservas do voo recebido. */

void ordenar_reservas(int buffer)
{
    int i,j;
    Reservas *temp;

    for (i=0; i<voos[buffer].count_reservas; i++){
        for (j=i+1; j<voos[buffer].count_reservas; j++){
            if(strcmp(voos[buffer].reservas[i]->c_reserva, voos[buffer].reservas[j]->c_reserva) > 0){
                temp = voos[buffer].reservas[i];
                voos[buffer].reservas[i] = voos[buffer].reservas[j];
                voos[buffer].reservas[j] = temp;
            }
        }
        printf("%s %d\n", voos[buffer].reservas[i]->c_reserva, voos[buffer].reservas[i]->passageiros);
    }
}

/* void lista_reserva(Reservas *hash_table[])
Esta função recebe uma hash table como argumento. Tem como objetivo fazer a 
distinção entre adicionar uma reserva ou listar as reservas de um voo
específico. A listagem só é feita após serem verificados os possíveis erros. */

void lista_reserva(Reservas *hash_table[])
{
    int dia, mes, ano, i, flag=0, buffer;
    char codigo_voo[DIM_CODIGO_MAX];
    char c;

    scanf("%s %d-%d-%d", codigo_voo, &dia, &mes, &ano);
    if ((c=getchar()) == '\n'){ 
        for(i=0; i<count_voos; i++){
            if(strcmp(voos[i].codigo, codigo_voo)==0 && voos[i].dia==dia && voos[i].mes==mes && voos[i].ano==ano){
                flag = 1;
                buffer = i;
                break;
            }
        }
        if(flag == 0){
            printf("%s: flight does not exist\n", codigo_voo);
            return;
        }
        if (ano<ANO_MIN || ano>ANO_MAX){
            printf("invalid date\n");
            return;
        }else if (ano > data_atual.ano && mes > data_atual.mes){
            printf("invalid date\n");
            return;
        }else if (ano > data_atual.ano && mes == data_atual.mes && dia > 
        data_atual.dia){
            printf("invalid date\n");
            return;
        }else if (ano < data_atual.ano){
            printf("invalid date\n");
            return;
        }else if (ano == data_atual.ano && mes < data_atual.mes){
            printf("invalid date\n");
            return;
        }else if (ano == data_atual.ano && mes == data_atual.mes && dia < 
        data_atual.dia){
            printf("invalid date\n");
            return;
        }      
        ordenar_reservas(buffer);
    }else{
        adiciona_reserva(codigo_voo, dia, mes, ano, hash_table);
    }
           
    return;
}

/* void elimina_reserva(int buffer_voo, int buffer_reserva)
Esta função recebe dois buffers (um respetivo ao índice do código de voo e
outro correspondente ao índice do código de reserva) como argumentos.
Tem como objetivo apenas eliminar uma reserva num determinado voo 
após acionado o comando "e".*/

void elimina_reserva(int buffer_voo, int buffer_reserva)
{
    int i;

    voos[buffer_voo].passageiros -= voos[buffer_voo].reservas[buffer_reserva]->passageiros;
    free(voos[buffer_voo].reservas[buffer_reserva]->c_reserva);
    free(voos[buffer_voo].reservas[buffer_reserva]->c_voo);
    free(voos[buffer_voo].reservas[buffer_reserva]);

    if (voos[buffer_voo].count_reservas == 1){
        voos[buffer_voo].count_reservas--;
    } else{
        for (i=buffer_reserva; i<voos[buffer_voo].count_reservas-1; i++){
            voos[buffer_voo].reservas[i] = voos[buffer_voo].reservas[i+1];
        }
        voos[buffer_voo].count_reservas--;
    }    
    voos[buffer_voo].reservas = realloc(voos[buffer_voo].reservas, sizeof(Reservas*)*voos[buffer_voo].count_reservas);
    if (voos[buffer_voo].reservas == NULL && voos[buffer_voo].count_reservas != 0){
        printf("No memory.\n");
        exit(0);
    }
    return;    
}

/* void elimina_voo(char codigo[], Reservas *hash_table[])
Esta função recebe um código de voo e um ponteiro para uma hash table como 
argumentos. Tem como objetivo apenas eliminar um voo como todas as suas 
reservas após acionado o comando "e".*/

void elimina_voo(char codigo[], Reservas *hash_table[])
{
    int i,j;

    for (i=0; i<count_voos; i++){
        if (count_voos==0)
            break;
        else if (strcmp(voos[i].codigo, codigo) == 0){
            for(j=0; j<voos[i].count_reservas;j++){
                elimina_hash(voos[i].reservas[j]->c_reserva, hash_table);
                free(voos[i].reservas[j]->c_reserva);
                free(voos[i].reservas[j]->c_voo);
                free(voos[i].reservas[j]); 
            }
            free(voos[i].reservas);
            for(j=i; j<count_voos-1; j++){
                voos[j] = voos[j+1];
            }
            i--;
            count_voos--;
        }
    }    
    return; 
}

/* void verifica_codigo(Reservas *hash_table[])
Esta função recebe um ponteiro para uma hash table como argumento. 
Tem como objetivo fazer a distinção entre eliminar uma reserva ou 
eliminar um voo. Se o código for inválido imprime o erro. */

void verifica_codigo(Reservas *hash_table[])
{
    char codigo[MAX_CAR];
    int i,j,len, flag=0, buffer_voo, buffer_reserva;

    scanf("%s", codigo);
    len = strlen(codigo);
    if (len < 10){
        for (i=0; i<count_voos; i++){
            if (strcmp(voos[i].codigo, codigo) == 0){
                flag = 1;
            }
            if (flag == 1){
                elimina_voo(codigo, hash_table);
                return;
            }               
        }
    }else{
        for (i=0; i<count_voos; i++){
            for(j=0; j<voos[i].count_reservas; j++){
                if (strcmp(voos[i].reservas[j]->c_reserva, codigo) == 0){
                    flag = 1;
                    buffer_voo = i;
                    buffer_reserva = j;
                }
                if(flag==1){
                    elimina_hash(codigo, hash_table);
                    elimina_reserva(buffer_voo, buffer_reserva);
                    return;
                }
            }               
        }
    }
    printf("not found\n");
    return;    
}


/* int main()
Função base do programa. Analisa os comandos dados pelo utilizador
e atribui a data inicial do sistema.*/

int main(){
    int run = 1, i, j;
    char comando, opcional_l, opcional_v;
    Reservas *hash_table[DIM_TAB];

    init_hash(hash_table);
    data_atual.dia = 1;
    data_atual.mes = 1;
    data_atual.ano = 2022;

    while (run == 1){
        scanf("%c", &comando);
        switch(comando){
            case 'q':
                for (i=0; i<count_voos; i++)
                {
                    for(j=0; j<voos[i].count_reservas; j++)
                    {
                        free(voos[i].reservas[j]->c_voo);
                        free(voos[i].reservas[j]->c_reserva);
                        free(voos[i].reservas[j]);
                    }      
                    free(voos[i].reservas);             
                }

                return 0;
                break;
            
            case 'a':
                getchar();
                adiciona_aeroporto();
                break;
            case 'l':
                opcional_l = getchar();
                lista_aeroporto(opcional_l);
                break;
            case 'v':
                opcional_v = getchar();
                lista_voos(opcional_v);
                break;
            case 't':
                getchar();
                altera_data();
                break;
            case 'p':
                getchar();
                lista_voos_p();
                break;
            case 'c':
                getchar();
                lista_voos_c();
                break;
            case 'r':
                getchar();
                lista_reserva(hash_table);
                break;
            case 'e':
                getchar();
                verifica_codigo(hash_table);
                break;
        }
    }
    return 0;
}
