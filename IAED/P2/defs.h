/* Diogo Pinto | 103259 |  Projeto 2 IAED | 2021/22 */

#ifndef DEFS_H
#define DEFS_H

/* Definição das constantes a utilizar neste projeto */
#define DIM_PAIS 31
#define DIM_CID 51
#define DIM_ID 4
#define DIM_CODIGO_MAX 7
#define N_AERO 40
#define N_VOOS 30000
#define CAPACIDADE_MIN 10
#define ANO_MIN 2022
#define ANO_MAX 2023
#define HORAS_MAX 12
#define DIM_OUTPUT 3
#define MAX_CAR 65535
#define DIM_TAB 40927

struct Aeroporto {
    char id[DIM_ID];
    char pais[DIM_PAIS];
    char cidade[DIM_CID];
    int voos;
};

typedef struct stru_Reservas{
    char *c_voo;
    int dia;
    int mes;
    int ano;
    char *c_reserva;
    int passageiros;
    struct stru_Reservas *prox;
}Reservas;

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
    int passageiros;
    Reservas **reservas;
    int count_reservas;
};

/*Declaração de Funcões a serem utilizadas*/

int data_chegada();
int sort_data_p(int c);
int sort_data_c(int c);
int adiciona_aeroporto();
int lista_manual();
int lista_aeroporto(char opcional_l);
int adiciona_voo();
int lista_voos(char opcional_v);
int altera_data();
int lista_voos_p();
int lista_voos_c();

int hash(char *codigo_reserva);
void init_hash(Reservas *hash_table[]);
void adiciona_hash(Reservas *r, Reservas *hash_table[]);
Reservas *procura_hash(char *codigo_reserva, Reservas *hash_table[]);
void elimina_hash(char *codigo_reserva, Reservas *hash_table[]);
void adiciona_reserva(char codigo_voo[], int dia, int mes, int ano, Reservas *hash_table[]);
void ordenar_reservas(int buffer);
void lista_reserva(Reservas *hash_table[]);
void elimina_reserva(int buffer_voo, int buffer_reserva);
void elimina_voo(char codigo[], Reservas *hash_table[]);
void verifica_codigo(Reservas *hash_table[]);

#endif