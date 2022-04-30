/* Diogo Pinto | 103259 |  Projeto 1 IAED | 2021/22 */

/* Definição das bibliotecas a utilizar neste projeto */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

/* Definição das constantes a utilizar neste projeto */
#define DIM_PAIS 31
#define DIM_CID 51
#define DIM_ID 4
#define DIM_CODIGO_MAX 7
#define N_AERO 40
#define N_VOOS 30000
#define CAPACIDADE_MAX 100
#define CAPACIDADE_MIN 10
#define ANO_MIN 2022
#define ANO_MAX 2023
#define HORAS_MAX 12
#define DIM_OUTPUT 3

int count_aeroportos = 0; /*Count utilizado para os aeroportos*/
int count_voos = 0; /*Count utilizado para os voos*/
char buffer_id[N_AERO][DIM_ID]; /*Variável temporária - ids*/
char buffer_codigo[N_VOOS][DIM_CODIGO_MAX]; /*Variável temporária - codigos*/

struct Aeroporto {
    char id[DIM_ID];
    char pais[DIM_PAIS];
    char cidade[DIM_CID];
    int voos;
};
struct Aeroporto aeroportos[N_AERO], temp;
/*Vetor de Aeroportos e struct temporária*/

struct Voos {
    char codigo[DIM_CODIGO_MAX];
    char id_p[DIM_ID];
    char id_c[DIM_ID];
    int capacidade;
    int dia;
    int mes;
    int ano;
    int dia_c;
    int mes_c;
    int ano_c;
    int hora;
    int minutos;
    int hora_c;
    int minutos_c;
    int hora_d;
    int minutos_d;
};
struct Voos voos[N_VOOS], temp_v, v_sort[N_VOOS], data_atual; 
/*Vetor de Voos, struct temporária, vetor de sorting e data atual*/

/* int data_chegada()
Esta função não recebe argumentos. Tem como único propósito calcular as datas e 
horas de chegada de um voo quando adicionado.*/

int data_chegada(){
    int horas_counter=0, dias_counter=0, meses_counter=0, anos_counter=0;

    voos[count_voos].minutos_c = voos[count_voos].minutos + 
    voos[count_voos].minutos_d;
    if (voos[count_voos].minutos_c > 59){
        voos[count_voos].minutos_c -= 60;
        horas_counter++;
    }
    if (horas_counter == 1)
        voos[count_voos].hora_c = voos[count_voos].hora + 
        voos[count_voos].hora_d + 1;
    else
        voos[count_voos].hora_c = voos[count_voos].hora + 
        voos[count_voos].hora_d;
    if (voos[count_voos].hora_c > 23){
        voos[count_voos].hora_c -= 24;
        dias_counter++;
    }
    if (dias_counter == 1)
        voos[count_voos].dia_c = voos[count_voos].dia + 1;
    else
        voos[count_voos].dia_c = voos[count_voos].dia;
    if (voos[count_voos].dia_c > 31 && (voos[count_voos].mes == 1 || 
    voos[count_voos].mes == 3 || voos[count_voos].mes == 5 || 
    voos[count_voos].mes == 7 ||  voos[count_voos].mes == 8 || 
    voos[count_voos].mes == 10 || voos[count_voos].mes == 12)){
        voos[count_voos].dia_c -= 31;
        meses_counter++;
    }
    if (voos[count_voos].dia_c > 30 && (voos[count_voos].mes == 4 || 
    voos[count_voos].mes == 6 || voos[count_voos].mes == 9 || 
    voos[count_voos].mes == 11)){
        voos[count_voos].dia_c -= 30;
        meses_counter++;
    }
    if (voos[count_voos].dia_c > 28 && voos[count_voos].mes == 2) {
        voos[count_voos].dia_c -= 28;
        meses_counter++;
    }
    if (meses_counter == 1)
        voos[count_voos].mes_c = voos[count_voos].mes + 1;
    else
        voos[count_voos].mes_c = voos[count_voos].mes;
    if (voos[count_voos].mes_c > 12){
        voos[count_voos].mes_c -= 12;
        anos_counter++;
    }
    if (anos_counter == 1)
        voos[count_voos].ano_c = voos[count_voos].ano + 1;  
    else
        voos[count_voos].ano_c = voos[count_voos].ano;        
    return 0;
}

/* int sort_data_p(int c)
Esta função recebe um argumento. O inteiro "c", corresponde ao número de voos 
associados a um aeroporto. O objetivo desta função é exatamente ordenar pela 
respetiva data os voos com partida no aeroporto em questão.*/

int sort_data_p(int c){
    int i,j;
  
    for (i=0; i<c; i++){
        for (j=i+1; j<c; j++){
            if (v_sort[i].ano > v_sort[j].ano){
                temp_v = v_sort[i];
                v_sort[i] = v_sort[j];
                v_sort[j] = temp_v;
            }else if (v_sort[i].ano == v_sort[j].ano){
                if (v_sort[i].mes > v_sort[j].mes){
                    temp_v = v_sort[i];
                    v_sort[i] = v_sort[j];
                    v_sort[j] = temp_v;
                }else if (v_sort[i].mes == v_sort[j].mes){
                    if (v_sort[i].dia > v_sort[j].dia){
                        temp_v = v_sort[i];
                        v_sort[i] = v_sort[j];
                        v_sort[j] = temp_v;
                    }else if (v_sort[i].dia == v_sort[j].dia){
                        if (v_sort[i].hora > v_sort[j].hora){
                            temp_v = v_sort[i];
                            v_sort[i] = v_sort[j];
                            v_sort[j] = temp_v;
                        }else if (v_sort[i].hora == v_sort[j].hora){
                            if (v_sort[i].minutos > v_sort[j].minutos){
                                temp_v = v_sort[i];
                                v_sort[i] = v_sort[j];
                                v_sort[j] = temp_v;
                            }
                        }
                    }
                }
            }
        }
    }
    return 0;
}

/* int sort_data_c(int c)
Esta função recebe um argumento. O inteiro "c", corresponde ao número de voos 
associados a um aeroporto. O objetivo desta função é exatamente ordenar pela 
respetiva data os voos com chegada no aeroporto em questão.*/

int sort_data_c(int c){
    int i, j;

    for (i=0; i<c; i++){
        for (j=i+1; j<c; j++){
            if (v_sort[i].ano_c > v_sort[j].ano_c){
                temp_v = v_sort[i];
                v_sort[i] = v_sort[j];
                v_sort[j] = temp_v;
            }else if (v_sort[i].ano_c == v_sort[j].ano_c){
                if (v_sort[i].mes_c > v_sort[j].mes_c){
                    temp_v = v_sort[i];
                    v_sort[i] = v_sort[j];
                    v_sort[j] = temp_v;
                }else if (v_sort[i].mes_c == v_sort[j].mes_c){
                    if (v_sort[i].dia_c > v_sort[j].dia_c){
                        temp_v = v_sort[i];
                        v_sort[i] = v_sort[j];
                        v_sort[j] = temp_v;
                    }else if (v_sort[i].dia_c == v_sort[j].dia_c){
                        if (v_sort[i].hora_c > v_sort[j].hora_c){
                            temp_v = v_sort[i];
                            v_sort[i] = v_sort[j];
                            v_sort[j] = temp_v;
                        }else if (v_sort[i].hora_c == v_sort[j].hora_c){
                            if (v_sort[i].minutos_c > v_sort[j].minutos_c){
                                temp_v = v_sort[i];
                                v_sort[i] = v_sort[j];
                                v_sort[j] = temp_v;
                            }
                        }
                    }
                }
            }
        }
    }
    return 0;
}

/* int adiciona_aeroporto()
Esta função não recebe argumentos. Tem como objetivo apenas criar um aeroporto
após acionado o comando "a". Esta criação é somente feita após se verificar os 
erros adjacentes, através do assigning na respetiva struct.*/

int adiciona_aeroporto(){   
    int i,j;
    char id[DIM_ID], pais[DIM_PAIS], cidade[DIM_CID]; 

    scanf("%s", id);
    scanf("%s", pais);
    getchar();
    scanf ("%[^\n]%*c", cidade);
    for (i=0; i<DIM_ID-1; i++){
        if (!isupper(id[i])){
            printf("invalid airport ID\n");
            return 0;
        }
    }
    if (count_aeroportos >= N_AERO){
        printf("too many airports\n");
        return 0;
    }
    for (j=0; j<count_aeroportos; j++){
        if (strcmp(id, buffer_id[j]) == 0){
            printf("duplicate airport\n");
            return 0;
        }
    }
    strcpy(buffer_id[count_aeroportos], id);
    strcpy(aeroportos[count_aeroportos].id, id);
    strcpy(aeroportos[count_aeroportos].pais, pais);
    strcpy(aeroportos[count_aeroportos].cidade, cidade);
    aeroportos[count_aeroportos].voos = 0;
    printf("airport %s\n", id); /* Output Final */
    count_aeroportos++; /* Incrementar a count de aeroportos */
    return 0;
}

/* int lista_manual()
Esta função não recebe argumentos. Tem como objetivo fazer a listagem manual 
dos aeroportos se o utilizador tiver inserido parâmetros após o comando "l". 
A listagem só é feita após serem verificados os possíveis erros.*/

int lista_manual(){
    int j, c;
    char f_check = ' ', id[DIM_ID]; /*f_check Verifica o final do input*/

    while (f_check != '\n') {
        c = 0;
        scanf("%s", id);
        for (j=0; j<count_aeroportos; j++){
            if (strcmp(id, aeroportos[j].id) == 0){
                printf("%s %s %s %d\n", aeroportos[j].id, aeroportos[j].cidade, 
                aeroportos[j].pais, aeroportos[j].voos);
                c++;
            }
        }
        if (c == 0)
            printf("%s: no such airport ID\n", id);
        f_check = getchar();
    }
    return 0;
}

/* int lista_aeroporto(char opcional_l)
Esta função recebe o argumento "opcional_l" que verifica se existem parâmetros
ou não após o comando inicial. O seu objetivo é fazer a listagem automática dos
aeroportos se o utilizador não tiver inserido parâmetros após o comando "l". 
A listagem só é feita após serem verificados os possíveis erros.*/

int lista_aeroporto(char opcional_l){
    int i, j;

    if (opcional_l == '\n'){
        for (i=0; i<count_aeroportos; i++){
            for (j=i+1; j<count_aeroportos; j++){
                if(strcmp(aeroportos[i].id, aeroportos[j].id) > 0){
                    temp = aeroportos[i];
                    aeroportos[i] = aeroportos[j];
                    aeroportos[j] = temp;
                }
            }
        }
        for (i=0; i<count_aeroportos; i++){
            printf("%s %s %s %d\n", aeroportos[i].id, aeroportos[i].cidade, 
            aeroportos[i].pais, aeroportos[i].voos); 
        }
    }else
        lista_manual();

    return 0;
}

/* int adiciona_voo()
Esta função não recebe argumentos. Tem como objetivo apenas criar um voo
após acionado o comando "v". Esta criação é somente feita após se verificar 
os erros adjacentes, através do assigning na respetiva struct.*/

int adiciona_voo(){
    int dia, mes, ano, hora, minutos, hora_d, minutos_d, capacidade, i, 
    len, exists_p=0, exists_c=0, aero;
    char codigo[DIM_CODIGO_MAX], id_p[DIM_ID], id_c[DIM_ID];

    scanf("%s %s %s %d-%d-%d %d:%d %d:%d %d", codigo, id_p, id_c, &dia, &mes, 
    &ano, &hora, &minutos, &hora_d, &minutos_d, &capacidade);
    len = strlen(codigo);
    if (len>6 || len<3){
        printf("invalid flight code\n");
        return 0;
    }
    for (i=0; i<len; i++){
        if (i<=1){
            if(!(codigo[i]>='A' && codigo[i]<='Z')){
                printf("invalid flight code\n");
                return 0;
            }
        }else if(!(codigo[i]>='0' && codigo[i]<='9')){
            printf("invalid flight code\n");
            return 0; 
        }
    }
    for (i=0; i<count_voos; i++){
        if (strcmp(codigo, buffer_codigo[i]) == 0){
            if((voos[i].dia == dia) && (voos[i].mes == mes) && 
            (voos[i].ano == ano)){
                printf("flight already exists\n");
                return 0;
            }
        }
    }   
    if (count_voos >= N_VOOS){
        printf("too many flights\n");
        return 0;
    }
    if (ano<ANO_MIN || ano>ANO_MAX){
        printf("invalid date\n");
        return 0;
    }else if (ano > data_atual.ano && mes > data_atual.mes){
        printf("invalid date\n");
        return 0;
    }else if (ano > data_atual.ano && mes == data_atual.mes && dia > 
    data_atual.dia){
        printf("invalid date\n");
        return 0;
    }else if (ano < data_atual.ano){
        printf("invalid date\n");
        return 0;
    }else if (ano == data_atual.ano && mes < data_atual.mes){
        printf("invalid date\n");
        return 0;
    }else if (ano == data_atual.ano && mes == data_atual.mes && dia < 
    data_atual.dia){
        printf("invalid date\n");
        return 0;
    }    
    if (hora_d > HORAS_MAX){
        printf("invalid duration\n");
        return 0;
    }
    if (hora_d == HORAS_MAX && minutos_d != 0){
        printf("invalid duration\n");
        return 0;
    }
    if (capacidade<CAPACIDADE_MIN || capacidade>CAPACIDADE_MAX){
        printf("invalid capacity\n");
        return 0;
    }
    for (i=0; i<count_aeroportos; i++){
        if (strcmp(aeroportos[i].id, id_p) == 0){
            exists_p = 1;
            aero = i;
        }
        if (strcmp(aeroportos[i].id, id_c) == 0){
            exists_c = 1;
        }     
    }
    if (exists_c == 0){
        printf("%s: no such airport ID\n", id_c);
        return 0;
    }
    if (exists_p == 0){
        printf("%s: no such airport ID\n", id_p);
        return 0;
    }else{
        aeroportos[aero].voos++; 
        /*Adicionar ao numero de voos no respetivo aeroporto*/
    }
    strcpy(buffer_codigo[count_voos], codigo);
    strcpy(voos[count_voos].codigo, codigo);
    strcpy(voos[count_voos].id_p, id_p);
    strcpy(voos[count_voos].id_c, id_c);
    voos[count_voos].capacidade = capacidade;
    voos[count_voos].dia = dia;
    voos[count_voos].mes = mes;
    voos[count_voos].ano = ano;
    voos[count_voos].hora = hora;
    voos[count_voos].minutos = minutos;
    voos[count_voos].hora_d = hora_d;
    voos[count_voos].minutos_d = minutos_d;    
    data_chegada(); /* Calcular a data de chegada */
    count_voos++; /* Incrementar a count de voos */
    return 0;
}

/* int lista_voos(char opcional_v)
Esta função recebe o argumento "opcional_v" que verifica se existem parâmetros
ou não após o comando inicial. O seu objetivo é fazer a listagem automática dos
voos se o utilizador não tiver inserido parâmetros após o comando "v". 
A listagem só é feita após serem verificados os possíveis erros.*/

int lista_voos(char opcional_v){
    int i;
    char dia[DIM_OUTPUT], mes[DIM_OUTPUT], hora[DIM_OUTPUT], 
    minutos[DIM_OUTPUT];

    if (opcional_v == '\n')
    {
        for (i=0; i<count_voos; i++)  
        /*Retificar o output das datas dado que guardei em int (leading 0)*/
        {   
            if (voos[i].dia<10)
            {
                dia[1] = voos[i].dia + '0';
                dia[0] = '0';
            }else
            {
                dia[0] = (voos[i].dia/10) + '0';
                dia[1] = (voos[i].dia%10) + '0';
            }
            if (voos[i].mes<10)
            {
                mes[1] = voos[i].mes + '0';
                mes[0] = '0';
            }else
            {
                mes[0] = (voos[i].mes/10) + '0';
                mes[1] = (voos[i].mes%10) + '0';
            }
            if (voos[i].hora<10)
            {
                hora[1] = voos[i].hora + '0';
                hora[0] = '0';
            }else
            {
                hora[0] = (voos[i].hora/10) + '0';
                hora[1] = (voos[i].hora%10) + '0';
            }            
            if (voos[i].minutos<10)
            {
                minutos[1] = voos[i].minutos + '0';
                minutos[0] = '0';
            }else
            {
                minutos[0] = (voos[i].minutos/10) + '0';
                minutos[1] = (voos[i].minutos%10) + '0';
            }
            printf("%s %s %s %c%c-%c%c-%d %c%c:%c%c\n", voos[i].codigo, 
            voos[i].id_p, voos[i].id_c, dia[0], dia[1], mes[0], mes[1], 
            voos[i].ano, hora[0], hora[1], minutos[0], minutos[1]);
        }
    }else
        adiciona_voo();
    return 0;
}

/* int altera_data()
Esta função não recebe argumentos. Tem como objetivo apenas alterar a data
após acionado o comando "t". Esta alteração é somente feita após se verificar 
os erros adjacentes, através do assigning na respetiva struct.*/

int altera_data(){
    int dia, mes, ano;
    char dia_c[3], mes_c[3];

    scanf("%d-%d-%d", &dia, &mes, &ano);
    if (ano<ANO_MIN || ano>ANO_MAX){
        printf("invalid date\n");
        return 0;
    }else if (ano > data_atual.ano && mes > data_atual.mes){
        printf("invalid date\n");
        return 0;
    }else if (ano > data_atual.ano && mes == data_atual.mes && dia > 
    data_atual.dia){
        printf("invalid date\n");
        return 0;
    }else if (ano < data_atual.ano){
        printf("invalid date\n");
        return 0;
    }else if (ano == data_atual.ano && mes < data_atual.mes){
        printf("invalid date\n");
        return 0;
    }else if (ano == data_atual.ano && mes == data_atual.mes && dia < 
    data_atual.dia){
        printf("invalid date\n");
        return 0;
    }
    data_atual.dia = dia;
    data_atual.mes = mes;
    data_atual.ano = ano;
    if (data_atual.dia<10){
        dia_c[1] = data_atual.dia + '0';
        dia_c[0] = '0';
    }else{
        dia_c[0] = (data_atual.dia/10) + '0';
        dia_c[1] = (data_atual.dia%10) + '0';
    }
    if (data_atual.mes<10){
        mes_c[1] = data_atual.mes + '0';
        mes_c[0] = '0';
    }else{
        mes_c[0] = (data_atual.mes/10) + '0';
        mes_c[1] = (data_atual.mes%10) + '0';
    }
    printf("%c%c-%c%c-%d\n", dia_c[0], dia_c[1], mes_c[0], mes_c[1], 
    data_atual.ano);
    return 0;
}

/* int lista_voos_p()
Esta função não recebe argumentos. Tem como objetivo listar os voos de partida
de um aeroporto específico acionado o comando "p". É utilizada uma variável
temporária que guarda os voos de partida do aeroporto pedido, à qual
posteriormente é dada sort.*/

int lista_voos_p(){
    char id[DIM_ID], dia[DIM_OUTPUT], mes[DIM_OUTPUT], hora[DIM_OUTPUT], 
    minutos[DIM_OUTPUT];
    int i, exists=0, j=0;
    scanf("%s", id);
    for (i=0; i<count_aeroportos; i++){
        if (strcmp(aeroportos[i].id, id) == 0){
            exists = 1;
        }   
    }
    if (exists == 0){
        printf("%s: no such airport ID\n", id);
        return 0;
    }
    for (i=0; i<count_voos; i++){
        if (strcmp(voos[i].id_p, id) == 0){
            v_sort[j] = voos[i];
            j++;
        }        
    }
    sort_data_p(j);
    for (i=0; i<j; i++){
        if (v_sort[i].dia<10){
            dia[1] = v_sort[i].dia + '0';
            dia[0] = '0';
        }else{
            dia[0] = (v_sort[i].dia/10) + '0';
            dia[1] = (v_sort[i].dia%10) + '0';
        }
        if (v_sort[i].mes<10){
            mes[1] = v_sort[i].mes + '0';
            mes[0] = '0';
        }else{
            mes[0] = (v_sort[i].mes/10) + '0';
            mes[1] = (v_sort[i].mes%10) + '0';
        }
        if (v_sort[i].hora<10){
            hora[1] = v_sort[i].hora + '0';
            hora[0] = '0';
        }else{
            hora[0] = (v_sort[i].hora/10) + '0';
            hora[1] = (v_sort[i].hora%10) + '0';
        }            
        if (v_sort[i].minutos<10){
            minutos[1] = v_sort[i].minutos + '0';
            minutos[0] = '0';
        }else{
            minutos[0] = (v_sort[i].minutos/10) + '0';
            minutos[1] = (v_sort[i].minutos%10) + '0';
        }
        printf("%s %s %c%c-%c%c-%d %c%c:%c%c\n", v_sort[i].codigo, 
        v_sort[i].id_c, dia[0], dia[1], mes[0], mes[1], v_sort[i].ano, 
        hora[0], hora[1], minutos[0], minutos[1]);
    }    
    return 0;
}

/* int lista_voos_c()
Esta função não recebe argumentos. Tem como objetivo listar os voos de chegada
de um aeroporto específico acionado o comando "c". É utilizada uma variável
temporária que guarda os voos de chegada do aeroporto pedido, à qual
posteriormente é dada sort.*/

int lista_voos_c(){
    char id[DIM_ID], dia[DIM_OUTPUT], mes[DIM_OUTPUT], hora[DIM_OUTPUT], 
    minutos[DIM_OUTPUT];
    int i, exists=0, j=0;
    scanf("%s", id);
    for (i=0; i<count_aeroportos; i++){
        if (strcmp(aeroportos[i].id, id) == 0){
            exists = 1;
        }   
    }
    if (exists == 0){
        printf("%s: no such airport ID\n", id);
        return 0;
    }
    for (i=0; i<count_voos; i++){
        if (strcmp(voos[i].id_c, id) == 0){
            v_sort[j] = voos[i];
            j++;
        }        
    }
    sort_data_c(j);
    for (i=0; i<j; i++){         
        if (v_sort[i].dia_c<10){
            dia[1] = v_sort[i].dia_c + '0';
            dia[0] = '0';
        }else{
            dia[0] = (v_sort[i].dia_c/10) + '0';
            dia[1] = (v_sort[i].dia_c%10) + '0';
        }
        if (v_sort[i].mes_c<10){
            mes[1] = v_sort[i].mes_c + '0';
            mes[0] = '0';
        }else{
            mes[0] = (v_sort[i].mes_c/10) + '0';
            mes[1] = (v_sort[i].mes_c%10) + '0';
        }
        if (v_sort[i].hora_c<10){
            hora[1] = v_sort[i].hora_c + '0';
            hora[0] = '0';
        }else{
            hora[0] = (v_sort[i].hora_c/10) + '0';
            hora[1] = (v_sort[i].hora_c%10) + '0';
        }            
        if (v_sort[i].minutos_c<10){
            minutos[1] = v_sort[i].minutos_c + '0';
            minutos[0] = '0';
        }else{
            minutos[0] = (v_sort[i].minutos_c/10) + '0';
            minutos[1] = (v_sort[i].minutos_c%10) + '0';
        }
        printf("%s %s %c%c-%c%c-%d %c%c:%c%c\n", v_sort[i].codigo, 
        v_sort[i].id_p, dia[0], dia[1], mes[0], mes[1], v_sort[i].ano_c, 
        hora[0], hora[1], minutos[0], minutos[1]);        
    }    
    return 0;
}

/* int main()
Função base do programa. Analisa os comandos dados pelo utilizador
e atribui a data inicial do sistema.*/

int main(){
    int run = 1;
    char comando, opcional_l, opcional_v;

    data_atual.dia = 1;
    data_atual.mes = 1;
    data_atual.ano = 2022;    
    while (run == 1){
        scanf("%c", &comando);
        switch(comando){
            case 'q':
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
        }
    }
    return 0;
}