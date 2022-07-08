; *********************************************************************************
; * Projeto IAC 2021/22 - IST-UL - Versão Final
; * Alunos: Diogo Pinto(103259), Rafael Sargento(103344), Henrique Costa(103663)
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA_TEC  EQU 1       ; linha a testar (1ª linha, 0001b)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

DEFINE_LINHA            EQU 600AH       ; endereço do comando para definir a linha
DEFINE_COLUNA           EQU 600CH       ; endereço do comando para definir a coluna
DEFINE_PIXEL            EQU 6012H       ; endereço do comando para escrever um pixel
APAGA_AVISO             EQU 6040H       ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ              EQU 6002H       ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU 6042H       ; endereço do comando para selecionar uma imagem de fundo
EMITE_SOM               EQU 605AH       ; endereço do comando para reproduzir o som

MIN_COLUNA      EQU  0                  ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA      EQU  59                 ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA       EQU  31                 ; número da linha mais a baixo que o objeto pode ocupar
MAX_LINHA_TIRO  EQU  16                 ; número da linha mais acima que o tiro pode ocupar
ATRASO          EQU 0FFFFH              ; atraso para limitar a velocidade de movimento do boneco

LINHA_BONECO    EQU 28                  ; linha default do boneco
COLUNA_BONECO   EQU 30                  ; coluna default do boneco

LINHA_TIRO   EQU 27                     ; linha default do tiro
COLUNA_TIRO   EQU 100                   ; coluna default do tiro (arbitária pois não existe tiro logo de início)

LARGURA_BONECO    EQU 5                 ; largura do boneco
ALTURA_BONECO     EQU 4                 ; altura do boneco

LINHA_METEORO  EQU 0                    ; linha default do meteoro
COLUNA_METEORO EQU -1                   ; coluna default do meteoro

LARGURA_METEORO_INIT_1   EQU 1          ; largura do meteoro - 1ª stage
ALTURA_METEORO_INIT_1    EQU 1          ; altura do meteoro - 1ª stage

LARGURA_METEORO_INIT_2   EQU 2          ; largura do meteoro - 2ª stage
ALTURA_METEORO_INIT_2    EQU 2          ; altura do meteoro - 2ª stage

LARGURA_METEORO_1    EQU 3              ; largura do meteoro - 3ª stage
ALTURA_METEORO_1     EQU 3              ; altura do meteoro - 3ª stage

LARGURA_METEORO_2    EQU 4              ; largura do meteoro - 4ª stage
ALTURA_METEORO_2     EQU 4              ; altura do meteoro - 4ª stage

LARGURA_METEORO_3    EQU 5              ; largura do meteoro - 5ª stage
ALTURA_METEORO_3     EQU 5              ; altura do meteoro - 5ª stage


TECLA EQU -1                            ; valor inicial do valor da tecla (calculado entre 0 e F)
ANTERIOR EQU -1                         ; valor inicial do valor da tecla (calculado entre 0 e F) pressionada anteriormente

LINHA_TECLA EQU -1                      ; reset à linha das teclas, no teclado

COR_PIXEL_AMARELO     EQU 0FFF0H        ; cor do pixel: amarelo em ARGB 
COR_PIXEL_VERMELHO    EQU 0FF00H        ; cor do pixel: vermelho em ARGB 
COR_PIXEL_CINZA       EQU 0F777H        ; cor do pixel: cinzento em ARGB
COR_PIXEL_VERDE       EQU 0C0F0H        ; cor do pixel: verde em ARGB
COR_PIXEL_CINZA_CLARO EQU 0FCCCH        ; cor do pixel: cinzento claro em ARGB
COR_PIXEL_AZUL_CLARO  EQU 0F0FFH        ; cor do pixel: azul em ARGB
COR_PIXEL_ROXO        EQU 0F85FH        ; cor do pixel: roxo em ARGB

; #######################################################################
; * ZONA DE DADOS 
; #######################################################################
PLACE       0FFEH

stack_init:                             ; rotina utilizada para definir o stack
    STACK 500H 

sp_init:

BTE_Start:                              ; rotina utilizada para definir o BTE
    WORD mover_meteoro
    WORD mover_tiro
    WORD mover_energia
    WORD 0

PLACE       02500H               

DEF_METEORO_FLAG:           ; WORD que define se a interrupção do meteoro foi corrida
    WORD                    0

DEF_ENERGIA_FLAG:           ; WORD que define se a interrupção da energia foi corrida
    WORD                    0

DEF_TIRO_FLAG:              ; WORD que define se a interrupção do tiro foi corrida
    WORD                    0

DEF_TIRO_TECLA_FLAG:        ; WORD que define se o tiro está a ser disparado
    WORD                    0

DEF_ACABA_FLAG:             ; WORD que define se o programa deve acabar ou não
    WORD                    0

DEF_COMECA_FLAG:            ; WORD que define se o programa deve começar do início ou não
    WORD                    0

DEF_BONECO:                 ; tabela que define o boneco (cor, largura, altura, pixels)      
    WORD                    LARGURA_BONECO
    WORD                    ALTURA_BONECO

    WORD                    0, 0, COR_PIXEL_CINZA, 0, 0       
    WORD                    0, COR_PIXEL_CINZA, COR_PIXEL_AZUL_CLARO, COR_PIXEL_CINZA, 0     
    WORD                    COR_PIXEL_CINZA, COR_PIXEL_CINZA_CLARO, COR_PIXEL_CINZA_CLARO, COR_PIXEL_CINZA_CLARO, COR_PIXEL_CINZA       
    WORD                    0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0      

DEF_POSICAO_BONECO:         ; tabela que define a posição do boneco
    WORD                    LINHA_BONECO
    WORD                    COLUNA_BONECO

DEF_METEORO_INIT_1:         ; tabela que define o meteoro stage 1 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_INIT_1
    WORD                    ALTURA_METEORO_INIT_1

    WORD                    COR_PIXEL_CINZA

DEF_METEORO_INIT_2:         ; tabela que define o meteoro stage 2 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_INIT_2
    WORD                    ALTURA_METEORO_INIT_2

    WORD                    COR_PIXEL_CINZA, COR_PIXEL_CINZA
    WORD                    COR_PIXEL_CINZA, COR_PIXEL_CINZA

DEF_METEORO_MAU_1:          ; tabela que define o meteoro mau stage 1 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_1
    WORD                    ALTURA_METEORO_1

    WORD                    COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO        
    WORD                    0, COR_PIXEL_VERMELHO, 0   
    WORD                    COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO   

DEF_METEORO_MAU_2:          ; tabela que define o meteoro mau stage 2 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_2
    WORD                    ALTURA_METEORO_2

    WORD                    COR_PIXEL_VERMELHO, 0, 0, COR_PIXEL_VERMELHO     
    WORD                    0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0    
    WORD                    0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0   
    WORD                    COR_PIXEL_VERMELHO, 0, 0, COR_PIXEL_VERMELHO  

DEF_METEORO_MAU_3:          ; tabela que define o meteoro mau stage 3 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_3
    WORD                    ALTURA_METEORO_3

    WORD                    COR_PIXEL_VERMELHO, 0, 0, 0, COR_PIXEL_VERMELHO      
    WORD                    COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO       
    WORD                    0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0      
    WORD                    COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO       
    WORD                    COR_PIXEL_VERMELHO, 0, 0, 0, COR_PIXEL_VERMELHO    

DEF_METEORO_BOM_1:          ; tabela que define o meteoro bom stage 1 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_1
    WORD                    ALTURA_METEORO_1

    WORD                    0, COR_PIXEL_VERDE, 0 
    WORD                    COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE         
    WORD                    0, COR_PIXEL_VERDE, 0   

DEF_METEORO_BOM_2:          ; tabela que define o meteoro bom stage 2 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_2
    WORD                    ALTURA_METEORO_2

    WORD                    0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0     
    WORD                    COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE    
    WORD                    COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE   
    WORD                    0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0  

DEF_METEORO_BOM_3:          ; tabela que define o meteoro bom stage 3 (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_3
    WORD                    ALTURA_METEORO_3

    WORD                    0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0      
    WORD                    COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE       
    WORD                    COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE      
    WORD                    COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE       
    WORD                    0, COR_PIXEL_VERDE, COR_PIXEL_VERDE, COR_PIXEL_VERDE, 0 

DEF_TIRO:                   ; tabela que define o tiro (cor, pixels) 
    WORD                    COR_PIXEL_ROXO

DEF_POSICAO_METEORO:        ; tabela que define a posição dos meteoros
    WORD                    LINHA_METEORO
    WORD                    COLUNA_METEORO

    WORD                    LINHA_METEORO
    WORD                    COLUNA_METEORO

    WORD                    LINHA_METEORO
    WORD                    COLUNA_METEORO

    WORD                    LINHA_METEORO
    WORD                    COLUNA_METEORO

DEF_POSICAO_TIRO:           ; tabela que define a posição do tiro
    WORD                    LINHA_TIRO
    WORD                    COLUNA_TIRO

DEF_TECLA:                  ; tabela que regista o valor da tecla pressionada e da anterior (-1 se nenhuma foi pressionada)
    WORD                    TECLA
    WORD                    ANTERIOR

DEF_ENERGIA:                ; tabela que define o indice da energia atual do rover
    WORD                    0

DEF_ENERGIA_VALORES:        ; tabela que define a energia atual do rover
    WORD                    100H, 95H, 90H, 85H, 80H, 75H, 70H, 65H, 60H, 55H, 50H, 45H, 40H, 35H, 30H, 25H, 20H, 15H, 10H, 5H, 0

DEF_RANDOM:                 ; tabela que define se o meteoro é bom ou mau
    WORD                    0  ;(0 bom)(1 mau)
    WORD                   -1  ;ghost
    WORD                    0  ;(0 bom)(1 mau)
    WORD                   -1  ;ghost
    WORD                    0  ;(0 bom)(1 mau)
    WORD                   -1  ;ghost
    WORD                    0  ;(0 bom)(1 mau)

DEF_MAX_LINHA:              ; WORD que define a linha máxima que o meteoro pode ocupar
    WORD                    MAX_LINHA

DEF_MAX_LINHA_TIRO:         ; WORD que define a linha máxima que o tiro pode ocupar
    WORD                    MAX_LINHA_TIRO

DEF_EXPLOSAO:               ; tabela que define a explosão (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_3  ;(largura igual à do meteoro)
    WORD                    ALTURA_METEORO_3   ;(altura igual à do meteoro)

    WORD                    0, COR_PIXEL_AZUL_CLARO, 0, COR_PIXEL_AZUL_CLARO, 0
    WORD                    COR_PIXEL_AZUL_CLARO, 0, COR_PIXEL_AZUL_CLARO, 0, COR_PIXEL_AZUL_CLARO
    WORD                    0, COR_PIXEL_AZUL_CLARO, 0, COR_PIXEL_AZUL_CLARO, 0
    WORD                    COR_PIXEL_AZUL_CLARO, 0, COR_PIXEL_AZUL_CLARO, 0, COR_PIXEL_AZUL_CLARO
    WORD                    0, COR_PIXEL_AZUL_CLARO, 0, COR_PIXEL_AZUL_CLARO, 0

DEF_VARIOS_FLAG:            ; WORD que define o índice do meteoro específico a ser tratado
    WORD                    0

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE      0

    MOV SP, sp_init                     ; inicialização do stack pointer
    MOV BTE, BTE_Start                  ; inicialização do BTE
    ; inicialização das interrupções
    EI0                                 
    EI1
    EI2
    EI

energia_init:
    MOV R0, 0                           
    MOV R6, -1
    MOV [DEF_TECLA], R6                 ; seta o valor da tecla inicial a -1
    MOV [DEF_TECLA+2], R6               ; seta o valor da tecla anterior a -1
    MOV [DEF_ACABA_FLAG], R0            ; seta o valor da flag para acabar o programa a 0
    MOV [DEF_ENERGIA_FLAG], R0          ; seta o valor da flag da interrupção da energia a 0
    MOV [DEF_METEORO_FLAG], R0          ; seta o valor da flag da interrupção do meteoro a 0
    MOV [DEF_TIRO_FLAG], R0             ; seta o valor da flag da interrupção do tiro a 0
    MOV [DEF_TIRO_TECLA_FLAG], R0       ; seta o valor da flag do tiro disparado a 0
    MOV [DEF_ENERGIA], R0               ; seta o valor do índice do mostrador de energia a 0
    MOV [DEF_VARIOS_FLAG], R0           ; seta o valor da flag do índice de cada meteoro a 0
    MOV [DEF_RANDOM], R0                ; seta o valor da natureza do 1º meteoro a 0
    MOV [DEF_RANDOM+4], R0              ; seta o valor da natureza do 2º meteoro a 0
    MOV [DEF_RANDOM+8], R0              ; seta o valor da natureza do 3º meteoro a 0
    MOV [DEF_RANDOM+12], R0              ; seta o valor da natureza do 4º meteoro a 0
    MOV R3, 100H                        ; seta o valor inicial a ser mostrado nos displays de energia
    MOV R1, DISPLAYS                    ; associa a R1 o endereço do mostrador   
    MOV [R1], R3                        ; muda o valor do mostrador para 100H

;###########################################################################################

ecra_init_check:
    MOV R1, [DEF_COMECA_FLAG]           ; associa R1 ao valor da flag que indica se o programa tem que ser restartado de início ou apenas do ecrã de morte
    CMP R1, 0                           ; verifica se a flag está a 0
    JNZ boneco_init                     ; se não, não dá load ao ecrã inicial

ecra_init:                              ; se sim,
    MOV  [APAGA_AVISO], R1              ; apaga o aviso de nenhum cenário selecionado
    MOV  [APAGA_ECRÃ], R1               ; apaga todos os pixels já desenhados
    MOV R2, 3                           ; cenário de fundo número 3
    MOV [SELECIONA_CENARIO_FUNDO], R2   ; seleciona o cenário de fundo
    MOV [DEF_COMECA_FLAG], R2           ; muda o valor da flag para um diferente de 0

ecra_loop:                              
    CALL teclado                        ; chama o teclado 
    MOV R3, [DEF_TECLA]                 ; associa R3 ao valor da tecla pressionada
    MOV R4, 0CH                         
    CMP R3, R4                          ; verifica se a tecla pressionada é a "C"
    JZ boneco_init                      ; se sim, começa o programa
    JMP ecra_loop                       ; se não, fica preso neste ciclo mais uma vez

;###########################################################################################

boneco_init:
    MOV R3, LINHA_METEORO               ; associa a R3 a linha default do meteoro
    MOV R4, COLUNA_METEORO              ; associa a R4 a coluna default do meteoro
    MOV [DEF_POSICAO_METEORO], R3       ; inicializa a linha do 1º meteoro
    MOV [DEF_POSICAO_METEORO+2], R4     ; inicializa a coluna do 1º meteoro
    MOV [DEF_POSICAO_METEORO+4], R3     ; inicializa a linha do 2º meteoro
    MOV [DEF_POSICAO_METEORO+6], R4     ; inicializa a coluna do 2º meteoro
    MOV [DEF_POSICAO_METEORO+8], R3     ; inicializa a linha do 3º meteoro
    MOV [DEF_POSICAO_METEORO+10], R4    ; inicializa a coluna do 3º meteoro
    MOV [DEF_POSICAO_METEORO+12], R3    ; inicializa a linha do 4º meteoro
    MOV [DEF_POSICAO_METEORO+14], R4    ; inicializa a coluna do 4º meteoro
    MOV R6, LINHA_TIRO                  ; associa a R6 a linha default do tiro
    MOV R7, COLUNA_TIRO                 ; associa a R7 a coluna default do tiro
    MOV [DEF_POSICAO_TIRO], R6          ; inicializa a linha do tiro
    MOV [DEF_POSICAO_TIRO+2], R7        ; inicializa a coluna do tiro

    MOV  [APAGA_AVISO], R1              ; apaga o aviso de nenhum cenário selecionado
    MOV  [APAGA_ECRÃ], R1               ; apaga todos os pixels já desenhados
    MOV  R1, 0                          ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1  ; seleciona o cenário de fundo
    MOV  R1, LINHA_BONECO               ; associa a linha inicial do boneco a R1
    MOV  R2, COLUNA_BONECO              ; associa a coluna inicial do boneco a R2
    MOV  R8, DEF_POSICAO_BONECO         ; associa R8 à memória da posição do boneco (neste caso linha)
    MOV  [R8], R1                       ; inicializa a linha do boneco com o valor inicial previamente definido (meio do ecrã)
    ADD  R8, 2                          ; associa R8 à memória da coluna do boneco
    MOV  [R8], R2                       ; inicializa a coluna do boneco com o valor inicial previamente definido (fundo do ecrã)
    CALL  desenha_boneco                ; procede a desenhar o boneco incial

random_init:
    MOV R6, DEF_POSICAO_METEORO         ; associa a R6 a tabela da posição do meteoro 
    MOV R0, [DEF_VARIOS_FLAG]           ; associa a R0 a flag do indice do meteoro
    ADD R6, R0                          ; associa a R6 o indice do meteoro a ser tratado

    ; bocado de código utilizado para gerar um número pseudo-aleatório
    MOV R1, TEC_COL                     
    MOVB R2, [R1]
    SHR R2, 5
    CMP R2, 1                           ; compara o número gerado com 1
    JGT mete_init_mau                   ; se o numero for entre (2-7) o meteoro será mau, entre (0-1) será bom

mete_init_bom:                          
    MOV R7, DEF_RANDOM                  ; associa a natureza do meteoro a R7
    ADD R7, R0                          ; coloca o indice correto do meteoro a ser tratado
    MOV R3, 0                           
    MOV [R7], R3                        ; seta a natureza a 0 (porque é bom)
    JMP coluna_random_init
    
mete_init_mau:
    MOV R7, DEF_RANDOM                  ; associa a natureza do meteoro a R7
    ADD R7, R0                          ; coloca o indice correto do meteoro a ser tratado
    MOV R4, 1                           
    MOV [R7], R4                        ; seta a natureza a 1 (porque é mau)

coluna_random_init:
    MOV R5, 8                           
    MUL R2, R5                          ; multiplica o número pseudo-aleatório por 8 (para nos dar uma coluna alatória)
    MOV [R6 +2], R2                     ; seta a coluna inicial do meteoro em questão 

varios_init: 
    MOV R11, 12                          
    CMP R0, R11                         ; verifica se já tratámo de todos os meteoros
    JZ final_varios_init                ; se sim, acaba esta rotina
    ADD R0, 4                           ; se não, passa para o próximo índice
    MOV [DEF_VARIOS_FLAG], R0           ; e guarda o índice na flag
    JMP random_init                     ; recomeça esta parte do programa para o próximo meteoro

final_varios_init:
    MOV [DEF_VARIOS_FLAG], R3           ; acaba o init, alterando o índice do meteoro novamente para 0

;###########################################################################################

main:                                   ;rotina mãe que controla o programa inteiro
    CALL teclado
    CALL check_boneco
    CALL check_reset
    CALL check_meteoro
    CALL check_meteoro_bom
    CALL check_energia
    CALL check_tecla_tiro
    CALL check_tiro
    CALL check_rover_meteoro
    CALL check_missil_meteoro
    CALL check_acaba_jogo_flag
    CALL check_pause
    JMP main


;###########################################################################################

teclado:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10

    MOV  R2, TEC_LIN                    ; endereço do periférico das linhas
    MOV  R3, TEC_COL                    ; endereço do periférico das colunas
    MOV  R5, MASCARA                    ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R7, 0
    MOV  R8, 0
    MOV  R9, 4

ciclo_tecla:
    MOV  R1, 0                          ; reset no registo R1 em relação aos valores anteriores 
    MOV  R6, LINHA_TEC                  ; inserir linha que será testada

espera_tecla:                           ; neste ciclo espera-se até uma tecla ser premida
    MOV  R1, R6                         ; testar a linhas
    MOVB [R2], R1                       ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]                       ; ler do periférico de entrada (colunas)
    AND  R0, R5                         ; elimina bits para além dos bits 0-3
    CMP  R0, 0                          ; há tecla premida?
    JZ   teste_tecla                    ; se nenhuma tecla premida nessa linha, testa outra
                       

transforma_linha_tecla:                 ; este ciclo vai transformar o numero da linha 1,2,4,8  em 0,1,2,3
    SHR R1, 1                           ; andar 1 para trás na ordem 1,2,4,8
    CMP R1, 0              
    JNZ transforma_linha_tecla_aux
    JMP transforma_coluna_tecla

transforma_coluna_tecla:    
    SHR R0, 1                           ; este ciclo vai transformar o numero da coluna 1,2,4,8  em 0,1,2,3
    CMP R0, 0                           ; andar 1 para trás na ordem 1,2,4,8
    JNZ transforma_coluna_tecla_aux

valor_tecla:
    MOV R10, [DEF_TECLA]                
    MOV [DEF_TECLA+2], R10              ; guarda em memória o valor da tecla anterior
    MUL R7, R9                          ; multiplica o valor da linha por 4 (valor guardado em R9)
    ADD R7, R8                          ; guarda no R7 o resultado da formula 4*linha + coluna
    MOV [DEF_TECLA], R7                 ; guarda em memoria o valor da tecla
    JMP final_tecla

transforma_linha_tecla_aux:             ; ciclo usado para saber quantas vezes foram necessarias SHR, para chegar a 0
    ADD R7, 1                           ; no fim do ciclo fica no R7 o valor da linha
    JMP transforma_linha_tecla

transforma_coluna_tecla_aux:            ; ciclo usado para saber quantas vezes foram necessarias SHR, para chegar a 0
    ADD R8, 1                           ; no fim do ciclo fica no R8 o valor da coluna
    JMP transforma_coluna_tecla

teste_tecla:
    CMP R6, 7                           ; verifica se chegámos à ultima linha a testar
    JGT reset_tecla 
    SHL R6, 1                           ; passa para a proxima linha a testar
    JMP espera_tecla

reset_tecla:                            ; ciclo para voltarmos a por a linha a ser testada a 1
    MOV R10, -1
    MOV [DEF_TECLA + 2], R10            ; quando nenhuma tecla esta a ser pressionada este valor esta a -1
    MOV [DEF_TECLA], R10

final_tecla:
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R3
    POP R2
    POP R1
    POP R0
    RET

;###########################################################################################

desenha_boneco:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8

    MOV R8, DEF_POSICAO_BONECO      ; endereço da tabela que define a linha do boneco          
    MOV R1, [R8]                    ; valor da linha do boneco
    ADD R8, 2                       ; endereço da tabela que define a coluna do boneco
    MOV R2, [R8]                    ; valor da coluna do boneco
    MOV R6, R2                      ; cópia da coluna do boneco
    MOV R4, DEF_BONECO              ; endereço da tabela que define a largura do boneco
    MOV R5, [R4]                    ; obtém a largura do boneco
    ADD R4, 2                       ; endereço da tabela que define a altura do boneco
    MOV R7, [R4]                    ; obtém a altura do boneco
    ADD R4, 2                       ; endereço das cores da primeira linha do boneco(a contar de cima)

desenha_pixels_boneco:              ; desenha os pixels do boneco a partir da tabela
    MOV  R3, [R4]                   ; obtém a cor do próximo pixel do boneco
    MOV  [DEFINE_LINHA], R1         ; seleciona a linha
    MOV  [DEFINE_COLUNA], R6        ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3         ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R4, 2                      ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R6, 1                      ; próxima coluna
    SUB  R5, 1                      ; menos uma coluna para tratar
    JNZ  desenha_pixels_boneco      ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                      ; coloca o valor da largura do boneco novamente no registo
    ADD  R1, 1                      ; passa para a próxima linha(ou seja a de baixo)
    SUB  R6, 5                      ; passando para uma nova linha temos de voltar para a coluna inicial onde desenhamos o boneco
    SUB  R7, 1                      ; estando desenhada mais uma linha subtraimos 1 ao valor das linhas que restam desenhar
    JNZ desenha_pixels_boneco       ; se ainda faltarem linhas por desenhar voltamos ao inicio do ciclo para desenhar a próxima

    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    JMP pre_atraso

    
check_boneco:
    PUSH R1
    MOV R1, [DEF_TECLA]            ; associa a R1 o valor da tecla atual
    ; verifica se é uma das teclas que ativa o mexer do boneco, e se for irá continuar a rotina
    CMP R1, 2                      
    JZ check_boneco_2               
    CMP R1, 0
    JZ check_boneco_2
    ; se não, volta para a main
    POP R1
    RET

check_boneco_2:
    POP R1

apaga_boneco:                       ; apaga o boneco a partir da tabela
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10


    MOV R8, DEF_POSICAO_BONECO      ; endereço da tabela que define a linha do boneco         
    MOV R1, [R8]                    ; valor da linha do boneco
    ADD R8, 2                       ; endereço da tabela que define a coluna do boneco
    MOV R2, [R8]                    ; valor da coluna do boneco
    MOV R6, R2                      ; cópia da coluna do boneco
    MOV R4, DEF_BONECO              ; endereço da tabela que define a largura do boneco
    MOV R5, [R4]                    ; obtém a largura do boneco
    ADD R4, 2                       ; endereço da tabela que define a altura do boneco
    MOV R7, [R4]                    ; obtém a altura do boneco

apaga_pixels_boneco:                ; apaga os pixels do boneco a partir da tabela
    MOV  R3, 0                      ; para apagar, a cor do pixel é sempre 0
    MOV  [DEFINE_LINHA], R1         ; seleciona a linha
    MOV  [DEFINE_COLUNA], R6        ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3         ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R6, 1                      ; próxima coluna
    SUB  R5, 1                      ; menos uma coluna para tratar
    JNZ  apaga_pixels_boneco        ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                      ; coloca o valor da largura do boneco novamente no registo
    ADD  R1, 1                      ; passa para a próxima linha(ou seja a de baixo)
    SUB  R6, 5                      ; passando para uma nova linha temos de voltar para a coluna inicial onde apagamos o boneco
    SUB  R7, 1                      ; estando apagada mais uma linha subtraimos 1 ao valor das linhas que restam apagar
    JNZ  apaga_pixels_boneco        ; se ainda faltarem linhas por apagar voltamos ao inicio do ciclo para apagar a próxima

coluna_seguinte:                    ; ciclo responsável por distinguir o sentido do movimento do boneco
    MOV R9, [DEF_TECLA]             ; valor da tecla premida
    CMP R9, 0                       ; se o valor da tecla for 0 queremos que ande para a esquerda(coluna anterior)
    JZ coluna_anterior
    CMP R9, 2                       ; se o valor da tecla for 2 queremos que ande para a direita(coluna posterior)
    JZ coluna_posterior

coluna_anterior:                    ; ciclo responsável por mover boneco para a esquerda
    CMP R2, MIN_COLUNA              ; se o boneco tocar na borda lateral esquerda deve ser desenhado na mesma posição,
    JZ final_apaga_pixels               ; não atravessando a parede
    ADD R2, -1                      ; se não estiver a tocar no limite lateral podemos mudar a coluna do boneco 1 pixel para a esquerda
    MOV [R8], R2                    ; atualizamos valor da coluna atual do boneco
    JMP final_apaga_pixels              ; alterando a coluna para o onde o queremos desenhar só falta desenhar

coluna_posterior:                   ; ciclo responsável por mover boneco para a direita
    MOV R10, MAX_COLUNA             ; se o boneco tocar na borda lateral direita deve ser desenhado na mesma posição,
    CMP R2, R10                     ; não atravessando a parede
    JZ final_apaga_pixels
    ADD R2, 1                       ; se não estiver a tocar no limite lateral podemos mudar a coluna do boneco 1 pixel para a direita
    MOV [R8], R2                    ; atualizamos valor da coluna atual do boneco

final_apaga_pixels:
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    JMP desenha_boneco              ; alterando a coluna para o onde o queremos desenhar só falta desenhar

;###########################################################################################

pre_atraso:
    PUSH R11
    MOV R11, ATRASO                 ; atraso para limitar a velocidade de movimento do boneco

ciclo_atraso:                       ; ciclo responsável por atrasar velocidade do boneco
    SUB R11, 1          
    JNZ ciclo_atraso
    POP R11
    RET

;###########################################################################################

check_energia:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4

    MOV R0, [DEF_ENERGIA_FLAG]      ; associa R0 à flag que demonstra se a interrupção foi corrida
    CMP R0, 0                       ; verifica se a flag está a 0
    JZ check_energia_ret            ; se sim, retorna para a main
    MOV R0, 0                       
    MOV [DEF_ENERGIA_FLAG], R0      ; se não, reseta a flag em questão

    MOV R1, [DEF_ENERGIA]           ; associa R1 ao índice da energia atual no mostrador
    ADD R1, 2                       ; passa o indice para a frente (diminui 5 de energia)
    MOV [DEF_ENERGIA], R1           ; guarda o indice novo na memória 

    CALL adiciona_display           

check_energia_ret:
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

adiciona_display:                   ; coloca a energia atualizada nos displays
    MOV R3, DEF_ENERGIA_VALORES     ; associa R3 ao mostrador de energia
    ADD R3, R1                      ; associa o índice correto para colocar no mostrador
    MOV R0, DISPLAYS                ; associa R0 ao endereço dos displays
    MOV R4, [R3]                    ; associa R4 ao conteúdo do mostrador
    MOV [R0], R4                    ; atualiza o valor da energia nos displays
    CMP R4, 0                       ; compara o valor da energia com 0
    JZ acaba_energia_flag           
    RET                             ; se não for 0 retorna à main

acaba_energia_flag:
    MOV R5, 1                       
    MOV [DEF_ACABA_FLAG], R5        ; se for 0, ativa a flag para acabar o jogo
    RET                             ; retorna à main

;###########################################################################################

;###########################################################################################

desenha_meteoro_mau: ; os valores anteriores dos registos usados são colocados na pilha
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    
; R8 -> posição atual dos meteoros
; R11 -> valor do meteoro a que queremos aceder( meteoros de 0 a 2)
; R9 -> cópia da linha do meteoro que após subtraida por 8 vai ser usada para definir em que fase está o meteoro

    MOV R8, DEF_POSICAO_METEORO
    MOV R11, [DEF_VARIOS_FLAG]
    ADD R8, R11                                 ; acede à linha do meteoro pretendido
    MOV R1, [R8]                                ; obtem a linha do meteoro    
    ADD R8, 2                                   ; R8 tem agora o endereço da coluna do meteoro pretendido
    MOV R2, [R8]                                ; obtem a coluna do meteoro
    MOV R6, R1                                  ; cópia da linha do meteoro
    MOV R9, R1                                  ; outra cópia da linha do meteoro
    ADD R9, -8                                  ; somamos -8 para não utilizar registos nas próximas comparações

    CMP R9, -5                                  ; verifica se o meteoro está nas linhas iniciais do ecrã
    JLT stage_init_1
    CMP R9, -2                                  ; após cada 3 linhas que o meteoro percorra
    JLT stage_init_2                            ; o stage no qual ele é desenahdo muda, ficando o meteoro assim
    CMP R9, 1                                   ; maior ao longo da descida
    JLT stage_meteoro_1
    CMP R9, 4
    JLT stage_meteoro_2
    JMP stage_meteoro_3

; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_init_1:                                   ; fase inicial do meteoro
    MOV R4, DEF_METEORO_INIT_1                  ; endereço da tabela que define o meteoro
    MOV R5, [R4]                                ; obtém a largura do meteoro
    MOV R10, [R4]                               ; obtém cópia da largura do meteoro
    ADD R4, 2                                   ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                                ; obtém a altura do meteoro
    ADD R4, 2                                   ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_mau              ; tendo estes dados vai desenhar
    
; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_init_2:
    MOV R4, DEF_METEORO_INIT_2                  ; endereço da tabela que define o meteoro
    MOV R5, [R4]                                ; obtém a largura do meteoro
    MOV R10, [R4]                               ; obtém cópia da largura do meteoro
    ADD R4, 2                                   ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                                ; obtém a altura do meteoro
    ADD R4, 2                                   ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_mau              ; tendo estes dados vai desenhar
    
; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_meteoro_1:
    MOV R4, DEF_METEORO_MAU_1                   ; endereço da tabela que define o meteoro
    MOV R5, [R4]                                ; obtém a largura do meteoro
    MOV R10, [R4]                               ; obtém cópia da largura do meteoro
    ADD R4, 2                                   ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                                ; obtém a altura do meteoro
    ADD R4, 2                                   ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_mau              ; tendo estes dados vai desenhar
    
; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_meteoro_2:
    MOV R4, DEF_METEORO_MAU_2                   ; endereço da tabela que define o meteoro
    MOV R5, [R4]                                ; obtém a largura do meteoro
    MOV R10, [R4]                               ; obtém cópia da largura do meteoro
    ADD R4, 2                                   ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                                ; obtém a altura do meteoro
    ADD R4, 2                                   ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_mau              ; tendo estes dados vai desenhar
    
; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_meteoro_3:
    MOV R4, DEF_METEORO_MAU_3                   ; endereço da tabela que define o meteoro
    MOV R5, [R4]                                ; obtém a largura do meteoro
    MOV R10, [R4]                               ; obtém cópia da largura do meteoro
    ADD R4, 2                                   ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                                ; obtém a altura do meteoro
    ADD R4, 2                                   ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_mau              ; tendo estes dados vai desenhar


desenha_pixels_meteoro_mau:                     ; desenha os pixels do meteoro a partir da tabela
    MOV  R3, [R4]                               ; obtém a cor do próximo pixel do meteoro
    MOV  [DEFINE_LINHA], R6                     ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                    ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                     ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R4, 2                                  ; endereço da cor do próximo pixel 
    ADD  R2, 1                                  ; próxima coluna
    SUB  R5, 1                                  ; menos uma coluna para tratar
    JNZ  desenha_pixels_meteoro_mau             ; continua até percorrer toda a largura do objeto
    MOV  R5, R10                                ; volta a por o numero de colunas a tratar para 5
    ADD  R6, 1                                  ; passa para a proxima linha
    SUB  R2, R10                                ; mete o valor da coluna atual a 0
    SUB  R7, 1                                  ; diminui 1 na altura do meteoro
    JNZ  desenha_pixels_meteoro_mau             ; continua até percorrer toda a altura do objeto

    POP R11                                     ; após desenhar o meteoro os registos voltam aos seus valores anteriores
    POP R10                                     ; utilizando o POP e depois é usado RET para voltar
    POP R9                                  
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

check_meteoro:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5

    MOV R0, [DEF_METEORO_FLAG]
    CMP R0, 0
    JZ check_meteoro_ret_2
    
    ; R5 -> posição atual do meteoro
    ; R4 -> valor do meteoro a que queremos aceder( meteoros de 0 a 2)

    MOV R5, DEF_POSICAO_METEORO
    MOV R4, [DEF_VARIOS_FLAG]
    ADD R5, R4                          ; acede à linha do meteoro pretendido

    ;#########################
    MOV R3, DEF_RANDOM
    ADD R3, R4
    MOV R3, [R3]
    CMP R3, 1                           ; verifica se meteoro é bom ou mau( mau = 1, bom = 0)
    JNZ check_meteoro_ret_2             ; se for bom não tem nada a fazer aqui logo vai para a rotina de retorno
    ;##########################

    MOV R1, [R5]                        ; obtém linha do meteoro
    ADD R1, 1                           ; anda uma linha para a frente
    MOV [R5], R1                        ; atualiza a linha atual do meteoro

    CALL apaga_meteoro_mau

check_meteoro_ret:
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0

mau_varios:
    MOV R2, 12                           ; 8 significa que os 3 meteoros já foram tratados
    MOV R0, [DEF_VARIOS_FLAG]           ; FLAG que guarda em que meteoro estamos
    CMP R0, R2                          ; compara seo último meteoro já foi tratado
    JZ termina_mau_varios               ; se já foi tratado o último vai para a rotina que reseta a FLAG
    ADD R0, 4                           ; caso contrário adiciona 4, atualizando a FLAG para tratar do próximo meteoro
    MOV [DEF_VARIOS_FLAG], R0
    JMP check_meteoro                   ; repete o processo para o próximo meteoro

termina_mau_varios:                     ; rotina que reseta a FLAG e que volta para a main
    MOV R0, 0
    MOV [DEF_METEORO_FLAG], R0

    MOV R1, 0
    MOV [DEF_VARIOS_FLAG], R1 
    RET                                 ; volta para a main


check_meteoro_ret_2:
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET


apaga_meteoro_mau:  
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R10
    PUSH R11
    
    ; R8 -> posição atual dos meteoros
    ; R11 -> valor do meteoro a que queremos aceder( meteoros de 0 a 2)

    MOV R8, DEF_POSICAO_METEORO
    MOV R11, [DEF_VARIOS_FLAG] 
    ADD R8, R11                             ; acede à linha do meteoro pretendido
    MOV R1, [R8]                            ; valor da linha do meteoro mau
    SUB R1, 1                               ; valor da linha do meteoro mau
    ADD R8, 2                               
    MOV R2, [R8]                            ; valor da coluna do meteoro mau
    MOV R6, R1                              ; cópia da linha do meteoro
    MOV R4, DEF_METEORO_MAU_3               ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    ADD R4, 2
    MOV R7, [R4]                            ; obtem a altura do meteoro

apaga_pixels_meteoro_mau:               
    MOV  R3, 0                              ; para apagar, a cor do pixel é sempre 0
    MOV  [DEFINE_LINHA], R6                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  apaga_pixels_meteoro_mau           ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                              ; volta a por o numero de colunas a tratar para 5
    ADD  R6, 1                              ; passa para a proxima linha
    SUB  R2, 5                              ; mete o valor da coluna atual a 0
    SUB  R7, 1                              ; diminui 1 na altura do meteoro
    JNZ  apaga_pixels_meteoro_mau           ; continua até percorrer toda a altura do objeto


linha_seguinte:
    MOV R10, [DEF_MAX_LINHA]                ; associa o valor da linha maxima ao R10
    CMP R1, R10                             ; compara o valor da linha maxima com a linha atual
    JGE linha_final_meteoro                 ; se o resultado for 0, volta para a main, apenas apagando o meteoro (saiu do ecra)

final_meteoro:
    POP R11
    POP R10
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    JMP desenha_meteoro_mau

linha_final_meteoro:
    POP R11
    POP R10
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

;###########################################################################################

desenha_meteoro_bom:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    
    ; R8 -> posição atual dos meteoros
    ; R11 -> valor do meteoro a que queremos aceder( meteoros de 0 a 2)
    ; R9 -> cópia da linha do meteoro que após subtraida por 8 vai ser usada para definir em que fase está o meteoro

    MOV R8, DEF_POSICAO_METEORO
    MOV R11, [DEF_VARIOS_FLAG]
    ADD R8, R11                             ; acede à linha do meteoro pretendido
    MOV R1, [R8]                            ; obtem a linha do meteoro    
    ADD R8, 2                               ; R8 tem agora o endereço da coluna do meteoro pretendido
    MOV R2, [R8]                            ; obtem a coluna do meteoro
    MOV R6, R1                              ; cópia da linha do meteoro
    MOV R9, R1                              ; outra cópia da linha do meteoro
    ADD R9, -8                              ; somamos -8 para não utilizar registos nas próximas comparações

    CMP R9, -5                              ; verifica se o meteoro está nas linhas iniciais do ecrã
    JLT stage_init_bom_1
    CMP R9, -2                              ; após cada 3 linhas que o meteoro percorra
    JLT stage_init_bom_2                    ; o stage no qual ele é desenahdo muda, ficando o meteoro assim
    CMP R9, 1                               ; maior ao longo da descida
    JLT stage_meteoro_bom_1
    CMP R9, 4
    JLT stage_meteoro_bom_2
    JMP stage_meteoro_bom_3

; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_init_bom_1:
    MOV R4, DEF_METEORO_INIT_1              ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    MOV R10, [R4]                           ; obtém cópia da largura do meteoro
    ADD R4, 2                               ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                            ; obtém a altura do meteoro
    ADD R4, 2                               ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_bom          ; tendo estes dados vai desenhar

; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_init_bom_2:
    MOV R4, DEF_METEORO_INIT_2              ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    MOV R10, [R4]                           ; obtém cópia da largura do meteoro
    ADD R4, 2                               ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                            ; obtém a altura do meteoro
    ADD R4, 2                               ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_bom          ; tendo estes dados vai desenhar

; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_meteoro_bom_1:
    MOV R4, DEF_METEORO_BOM_1               ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    MOV R10, [R4]                           ; obtém cópia da largura do meteoro
    ADD R4, 2                               ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                            ; obtém a altura do meteoro
    ADD R4, 2                               ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_bom          ; tendo estes dados vai desenhar

; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_meteoro_bom_2:
    MOV R4, DEF_METEORO_BOM_2               ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    MOV R10, [R4]                           ; obtém cópia da largura do meteoro
    ADD R4, 2                               ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                            ; obtém a altura do meteoro
    ADD R4, 2                               ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_bom          ; tendo estes dados vai desenhar

; R4 -> Registo que vai conter os valores da altura e largura do meteoro
; R5, R10 -> Largura do meteoro
; R7 -> Altura do meteoro
stage_meteoro_bom_3:
    MOV R4, DEF_METEORO_BOM_3               ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    MOV R10, [R4]                           ; obtém cópia da largura do meteoro
    ADD R4, 2                               ; obtém o endereço da altura do meteoro
    MOV R7, [R4]                            ; obtém a altura do meteoro
    ADD R4, 2                               ; obtém o endereço dos pixeis primeira linha a desenhar do meteoro
    JMP desenha_pixels_meteoro_bom          ; tendo estes dados vai desenhar


desenha_pixels_meteoro_bom:                 ; desenha os pixels do meteoro a partir da tabela
    MOV  R3, [R4]                           ; obtém a cor do próximo pixel do meteoro
    MOV  [DEFINE_LINHA], R6                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R4, 2                              ; endereço da cor do próximo pixel 
    ADD  R2, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  desenha_pixels_meteoro_bom         ; continua até percorrer toda a largura do objeto
    MOV  R5, R10                            ; volta a por o numero de colunas a tratar para 5
    ADD  R6, 1                              ; passa para a proxima linha
    SUB  R2, R10                            ; mete o valor da coluna atual a 0
    SUB  R7, 1                              ; diminui 1 na altura do meteoro
    JNZ  desenha_pixels_meteoro_bom         ; continua até percorrer toda a altura do objeto

    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

check_meteoro_bom:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5

    MOV R0, [DEF_METEORO_FLAG]
    CMP R0, 0
    JZ check_meteoro_bom_ret_2
    
    ; R5 -> posição atual dos meteoros
    ; R4 -> valor do meteoro a que queremos aceder( meteoros de 0 a 2)

    MOV R5, DEF_POSICAO_METEORO
    MOV R4, [DEF_VARIOS_FLAG]
    ADD R5, R4                      ; acede à linha do meteoro pretendido

    ;#########################
    MOV R3, DEF_RANDOM
    ADD R3, R4
    MOV R3, [R3]
    CMP R3, 0                      ; verifica se meteoro é bom ou mau( mau = 1, bom = 0)
    JNZ check_meteoro_bom_ret_2    ; se for mau não tem nada a fazer aqui logo vai para a rotina de retorno
    ;##########################

    MOV R1, [R5]                   ; obtém linha do meteoro
    ADD R1, 1                      ; anda uma linha para a frente
    MOV [R5], R1                   ; atualiza a linha atual do meteoro

    CALL apaga_meteoro_bom   

check_meteoro_bom_ret:
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0

bom_varios:
    MOV R2, 12                     ; 8 significa que os 3 meteoros já foram tratados
    MOV R0, [DEF_VARIOS_FLAG]     ; FLAG que guarda em que meteoro estamos
    CMP R0, R2                    ; compara seo último meteoro já foi tratado
    JZ termina_bom_varios         ; se já foi tratado o último vai para a rotina que reseta a FLAG
    ADD R0, 4                     ; caso contrário adiciona 4, atualizando a FLAG para tratar do próximo meteoro
    MOV [DEF_VARIOS_FLAG], R0
    JMP check_meteoro_bom         ; repete o processo para o próximo meteoro

termina_bom_varios:               ; rotina que reseta a FLAG e que volta para a main
    MOV R0, 0
    MOV [DEF_METEORO_FLAG], R0
    MOV R1, 0
    MOV [DEF_VARIOS_FLAG], R1 
    RET

check_meteoro_bom_ret_2:
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET                          ; volta para a main


apaga_meteoro_bom:  
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R10
    PUSH R11
    
    ; R8 -> posição atual dos meteoros
    ; R11 -> valor do meteoro a que queremos aceder( meteoros de 0 a 2)

    MOV R8, DEF_POSICAO_METEORO
    MOV R11, [DEF_VARIOS_FLAG]
    ADD R8, R11                             ; acede à linha do meteoro pretendido
    MOV R1, [R8]                            ; valor da linha do meteoro
    SUB R1, 1                               ; valor da linha do meteoro
    ADD R8, 2                               
    MOV R2, [R8]                            ; valor da coluna do meteoro
    MOV R6, R1                              ; cópia da linha do meteoro
    MOV R4, DEF_METEORO_BOM_3               ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    ADD R4, 2
    MOV R7, [R4]                            ; obtem a altura do meteoro

apaga_pixels_meteoro_bom:               
    MOV  R3, 0                              ; para apagar, a cor do pixel é sempre 0
    MOV  [DEFINE_LINHA], R6                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  apaga_pixels_meteoro_bom           ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                              ; volta a por o numero de colunas a tratar para 5
    ADD  R6, 1                              ; passa para a proxima linha
    SUB  R2, 5                              ; mete o valor da coluna atual a 0
    SUB  R7, 1                              ; diminui 1 na altura do meteoro
    JNZ  apaga_pixels_meteoro_bom           ; continua até percorrer toda a altura do objeto


linha_seguinte_bom:
    MOV R10, [DEF_MAX_LINHA]                ; associa o valor da linha maxima ao R10
    CMP R1, R10                             ; compara o valor da linha maxima com a linha atual
    JGE linha_final_meteoro_bom             ; se o resultado for 0, volta para a main, apenas apagando o meteoro (saiu do ecra)

final_meteoro_bom:
    POP R11
    POP R10
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    JMP desenha_meteoro_bom

linha_final_meteoro_bom:
    POP R11
    POP R10
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

;###########################################################################################

check_reset:                             ; verifica se o meteoro já chegou ao fim do ecrã
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    
    ; R1 -> posição atual dos meteoros
    ; R0 -> valor do meteoro a que queremos aceder( meteoros de 0 a 2)

    MOV R1, DEF_POSICAO_METEORO
    MOV R0, [DEF_VARIOS_FLAG]
    ADD R1, R0                           ; acede à linha do meteoro pretendido

    MOV R11, [R1]                        ; obtém linha do meteoro
    MOV R2, MAX_LINHA
    CMP R11, R2                          ; verifica se o meteoro está na linha final do ecrã
    JGT reset_linha                      ; se sim vai para a rotina que retorna o meteoro para a linha 0
    JMP reset_ret

reset_linha:
    MOV R3, 0
    MOV [R1], R3

random_meteoro:                         ; rotina responsável por definir se o meteoro
    MOV R4, TEC_COL                     ; é bom ou mau ( 75% mau ; 25% bom)
    MOVB R5, [R4]
    SHR R5, 5
    CMP R5, 1
    JGT mete_mau

mete_bom:
    MOV R6, DEF_RANDOM
    ADD R6, R0
    MOV [R6], R3
    JMP random_coluna
    
mete_mau:
    MOV R3, 1
    MOV R7, DEF_RANDOM
    ADD R7, R0
    MOV [R7], R3

random_coluna:                          ; rotina responsável por definir em que coluna
    MOV R9, TEC_COL                     ; random nasce o meteoro
    MOVB R10, [R9]
    SHR R10, 5
    MOV R8, 8
    MUL R10, R8

    MOV [R1+2], R10

reset_ret:
    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1

reset_varios:   
    MOV R2, 12                           ; 8 significa que os 3 meteoros já foram tratados
    MOV R0, [DEF_VARIOS_FLAG]           ; FLAG que guarda em que meteoro estamos
    CMP R0, R2                          ; compara se o último meteoro já foi tratado
    JZ termina_varios_reset             ; se já foi tratado o último vai para a rotina que reseta a FLAG
    ADD R0, 4                           ; caso contrário adiciona 4, atualizando a FLAG para tratar do próximo meteoro
    MOV [DEF_VARIOS_FLAG], R0
    JMP check_reset                     ; repete o processo para o próximo meteoro

termina_varios_reset:                   ; rotina que reseta a FLAG e que volta para a main
    MOV R1, 0
    MOV [DEF_VARIOS_FLAG], R1 
    RET
;###########################################################################################

check_tecla_tiro:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    
    ; R4 -> posição atual do tiro
    ; R5 -> posição inicial do tiro

    MOV R4, [DEF_POSICAO_TIRO]
    MOV R5, LINHA_TIRO
    CMP R4, R5                      ; verifica se não existe outro tiro
    JNZ check_tecla_tiro_ret        ; se existir R4 não terá valor igual à posição inicial logo não vai ser feito outro tiro

    MOV R1, [DEF_TECLA]             ; verifica se a tecla premida foi o 1
    MOV R2, 1                       ; pois 1 é a tecla atribuida para a execução do disparo
    CMP R1, R2
    JNZ check_tecla_tiro_ret        ; se a tecla não for o 1 vai para a rotina que volta para a main
    MOV R1, [DEF_TECLA+2]           ; verifica se a tecla anterior também é 1
    CMP R1, 1                       ; isso significaria que o utilizador não largou a tecla
    JZ check_tecla_tiro_ret         ; não largar a tecla não produz mais disparos logo é 
                                    ; redirecionado para a rotina que volta para a main
ativa_flag_tiro:                    ; rotina que ativa a FLAG para mostrar que existe um tiro
    MOV R3, 1
    MOV [DEF_TIRO_TECLA_FLAG], R3 

seta_coluna_tiro:                   ; rotina que define em que posição vai nascer o tiro
    MOV R6, [DEF_POSICAO_BONECO+2]  ; obviamente é no meio do rover pelo que obtemos o valor da coluna
    ADD R6, 2                       ; mais à esquerda e somamos 2 para obter a coluna do meio
    MOV [DEF_POSICAO_TIRO+2], R6    ; atualizamos esse valor para o valor da coluna_posicao_tiro


diminui_energia_tiro:               ; ao produzir um tiro perdemos 5 de energia
    MOV R10, [DEF_ENERGIA]          ; obtém o count da posiçao atual na tabela da energia
    ADD R10, 2                      ; para diminuir simplesmente saltamos para a próxima WORD
    MOV [DEF_ENERGIA], R10          ; ou seja somamos 2 ao counter e atualizamos o valor
 
    MOV R8, DEF_ENERGIA_VALORES     ; obtém endereço da tabela das energias
    ADD R8, R10                     ; soma ao endereço que aponta para a energia incial (100) o counter, obtendo a energia atual
    MOV R0, DISPLAYS                ; endereço dos displays
    MOV R9, [R8]                    
    MOV [R0], R9                    ; atualiza o valor da energia nos displays
    CMP R9, 0                       ; verifica se a energia do rover chegou a 0
    JZ acaba_energia_tiro                  
    JMP faz_som

acaba_energia_tiro:                 ; se a energia chegou a 0
    MOV R10, 1    
    MOV [DEF_ACABA_FLAG], R10       ; ativamos a FLAG que indica o fim do jogo
    JMP check_tecla_tiro_ret


faz_som:                              
    MOV R7, 0
    MOV [EMITE_SOM], R7                     ; comando para emitir o som

check_tecla_tiro_ret:               ; rotina que executa POPS e volta para a main
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

;###########################################################################################

desenha_tiro:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R8

    MOV R8, DEF_POSICAO_TIRO              
    MOV R1, [R8]                            ; obtem a linha do tiro    
    ADD R8, 2
    MOV R2, [R8]                            ; obtem a coluna do tiro

    MOV  R4, DEF_TIRO                       ; endereço da tabela que define a forma e a cor do tiro
    MOV  R3, [R4]                           ; guarda a cor do pixel
    MOV  [DEFINE_LINHA], R1                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas

    POP R8
    POP R4
    POP R3
    POP R2
    POP R1
    RET

check_tiro:
    PUSH R0
    PUSH R1

    MOV R2, [DEF_TIRO_TECLA_FLAG]           ; flag que vai alertar o programa que a tecla esta a ser pressionada
    CMP R2, 0
    JZ check_tiro_ret                       ; caso não esteja a ser pressionada, volta para a main
    MOV R0, [DEF_TIRO_FLAG]                 ; flag que diz se está algum tiro no ecrã ou não
    CMP R0, 0
    JZ check_tiro_ret                       ; caso esteja algum tiro a ser disparado, volta para a main

    MOV R0, 0                               ; indicar ao programa que a partir deste momento está um tiro a ser disparado
    MOV [DEF_TIRO_FLAG], R0

    MOV R1, [DEF_POSICAO_TIRO]              ; subtrair 1 à linha do tiro, porque no "apaga_tiro", vai adicionar
    SUB R1, 1
    MOV [DEF_POSICAO_TIRO], R1 

    CALL apaga_tiro                         ; apagar o tiro da sua posicão atual e desenhar na proxima

    check_tiro_ret:                         ; voltar para o main depois de ter apagado e desenhado
    POP R1
    POP R0
    RET

    apaga_tiro:  
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R8
    PUSH R10

    MOV R8, DEF_POSICAO_TIRO              
    MOV R1, [R8]                            ; valor da linha do tiro
    ADD R1, 1                               ; valor da linha do tiro
    ADD R8, 2                               
    MOV R2, [R8]                            ; valor da coluna do tiro
              
    MOV  R3, 0                              ; para apagar, a cor do pixel é sempre 0
    MOV  [DEFINE_LINHA], R1                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas


linha_seguinte_tiro:
    MOV R10, [DEF_MAX_LINHA_TIRO]           ; associa o valor da linha maxima do tiro ao R10
    CMP R1, R10                             ; compara o valor da linha maxima do tiro com a linha atual
    JLE linha_final_tiro                    ; caso a linha do tira tiver passado a linha final, volta para a main

final_tiro:
    POP R10
    POP R8
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    JMP desenha_tiro

linha_final_tiro:
    MOV R4, 0                               ; resetar a flag do tiro
    MOV [DEF_TIRO_TECLA_FLAG], R4
    MOV R5, 27
    MOV [DEF_POSICAO_TIRO], R5              ; alterar a linha do tiro para 27, pois é o valor da linha da ponta do rover
    MOV R6, 100
    MOV [DEF_POSICAO_TIRO+2], R6            ; alterar a linha do tiro para 100, valor completamente arbitário

    POP R10
    POP R8
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

;###########################################################################################

check_acaba_jogo_flag:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

    MOV R1, [DEF_ACABA_FLAG]                ; se a flag que indica que o jogo deve acabar estiver a 1
    CMP R1, 1                               ; o programa vai desativar as interrupções
    JZ desativa_int

check_acaba_jogo:
    MOV R1, [DEF_TECLA]                     ; verificar se o jogo deve acabar por ordem do jogador
    MOV R2, 0EH
    CMP R1, R2
    JZ desativa_int
    JMP check_acaba_jogo_ret                ; caso o jogo não tenha de acabar o programa volta para a main

desativa_int:                               ; usado para desativar as 3 interrupções
    DI
    DI0
    DI1
    DI2

adiciona_fundo_acaba:                       ; usado para alterar o cenario de fundo para o cenerio de fim do jogo
    MOV R5, 0
    MOV [APAGA_ECRÃ], R5                    ; comando para apagar tudo o que esta no ecrã
    MOV R6, 1
    MOV [SELECIONA_CENARIO_FUNDO], R6       ; comando para selecionar um cenario de fundo arbitrario

acaba_jogo:                                 ; usado para verificar se o jogo deve de reniciar ou se deve continuar no ecra de fim de jogo
    CALL teclado
    MOV R3, [DEF_TECLA]
    MOV R4, 0CH
    CMP R3, R4
    JZ reinicia_jogo                        ; caso o utilizador eseja a pressionar a tecla C, o jogo vai reniciar
    JMP acaba_jogo                          ; caso contrario vai repetir o ciclo

reinicia_jogo:
    MOV SP, 0FFEH                           ; faz com que no proximo RET, o programa volte para o inicio do programa

check_acaba_jogo_ret:                       ; usado para fazer os POPS e para voltar para a main
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


;###########################################################################################

check_pause:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

    MOV R1, [DEF_TECLA]                     ; caso a tecla que o utilizador esteja a pressionar for o D, o jogo vai desativar as interrupções
    MOV R2, 0DH
    CMP R1, R2
    JZ desativa_int_pause
    JMP check_pause_ret                     ; caso contrario volta para a main

desativa_int_pause:                         ; usado para desativar as interrupções
    DI
    DI0
    DI1
    DI2

atraso_pausa:
    PUSH R11
    MOV R11, ATRASO              

ciclo_atraso_pausa:               
    SUB R11, 1          
    JNZ ciclo_atraso_pausa
    POP R11

atraso_pausa_2:
    PUSH R11
    MOV R11, ATRASO              

ciclo_atraso_pausa_2:               
    SUB R11, 1          
    JNZ ciclo_atraso_pausa_2
    POP R11

adiciona_fundo_pausa:                       ; usado para alterar o cenario de fundo para o cenerio de pausa
    MOV R5, 0
    MOV [APAGA_ECRÃ], R5                    ; comando para apagar tudo o que esta no ecrã
    MOV R6, 2
    MOV [SELECIONA_CENARIO_FUNDO], R6       ; comando para selecionar um cenario de fundo arbitrario

pausa_jogo:                                 ; usado para verificar se o jogo deve ficar em pausa ou se deve resumir o jogo
    CALL teclado
    MOV R3, [DEF_TECLA]
    MOV R4, 0DH
    CMP R3, R4
    JNZ pausa_jogo                          ; caso a tecla não seja D o jogo vai continuar em pausa
    MOV R5, [DEF_TECLA+2]   
    CMP R5, R4
    JNZ reativa_int_pausa                   ; se o jogo for resumir vai comecar por reativar as interrupcões
    JMP pausa_jogo

reativa_int_pausa:                          ; usado para reativar as interrupções
    EI0
    EI1
    EI2
    EI

atraso_pausa_3:
    PUSH R11
    MOV R11, ATRASO              

ciclo_atraso_pausa_3:               
    SUB R11, 1          
    JNZ ciclo_atraso_pausa_3
    POP R11

remove_fundo_pausa:                         ; usado para retirar o cenario da pausa e voltar ao fundo normal
    MOV R5, 0
    MOV [SELECIONA_CENARIO_FUNDO], R5       ; comando para selecionar um cenario de fundo arbitrario
    CALL desenha_boneco        

check_pause_ret:                            ; usado para fazer os POPS e voltar para a main
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


;###########################################################################################

check_rover_meteoro:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10

    MOV R7, DEF_POSICAO_METEORO
    MOV R8, [DEF_VARIOS_FLAG]           ; apontador para conseguirmos aceder ao meteoro que tamos a tratar
    ADD R7, R8                          ; agora R7 tem o endereco do meteoro atual

    MOV R1, 23
    MOV R2, [R7]
    CMP R1, R2                          ; se a linha do meteoro for inferior a 23 volta para a main, pois com certeza nao havera colisao rover-meteoro
    JGT check_rover_meteoro_ret
    MOV R1, [DEF_POSICAO_BONECO+2]
    MOV R2, [R7+2]
    ADD R2, 5                 
    CMP R1, R2                          ; se a coluna do rover for maior que a coluna do meteoro mais a sua largura (5) volta para a main, pois com certeza nao havera colisao rover-meteoro
    JGT check_rover_meteoro_ret
    MOV R1, [DEF_POSICAO_BONECO+2]
    MOV R2, [R7+2]
    ADD R1, 5
    CMP R2, R1                          ; se a coluna do meteoro for maior que a coluna do rover mais a sua largura (5) volta para a main, pois com certeza nao havera colisao rover-meteoro
    JGT check_rover_meteoro_ret
    JMP colisao_bom_mau

colisao_bom_mau:                        ; usado para decidir se vai haver uma colisao com um meteoro bom ou com um mau
    MOV R3, DEF_RANDOM
    ADD R3, R8                          ; usamos o apontador para conseguirmos aceder ao meteoro que tamos a tratar
    MOV R3, [R3]
    CMP R3, 0                           ; se o metoro em colisao for mau, proseguimos para acabar o jogo, caso contrario vamos adicionar energia
    JZ adiciona_energia_colisao 
    JMP acaba_jogo_colisao

adiciona_energia_colisao:
    MOV R4, [DEF_ENERGIA]
    CMP R4, 4                           ; verifica se a energia já não está no limite
    JLT check_rover_meteoro_ret
    SUB R4, 4                           ; equivale a recuar 2 words na tabela dos multiplos de 5 decrescentes ou seja aumentar 10 a energia
    MOV [DEF_ENERGIA], R4

    MOV R5, DEF_ENERGIA_VALORES
    ADD R5, R4
    MOV R0, DISPLAYS                    ; endereço dos displays
    MOV R6, [R5]
    MOV [R0], R6                        ; atualiza o valor da energia nos displays

    MOV R9, [R7]                        ; R7 tem o endereco do meteoro atual
    ADD R9, 1                           ; adicionar 1 na linha para quando for apagar, apagar na posicao certa
    MOV [R7], R9                        ; porque o apagar vai apagar da posicao anterior

    MOV R9, 15H                         ; alteramos o valor da max_linha para que ele consiga dar reset e nascer um novo
    MOV [DEF_MAX_LINHA], R9
    CALL apaga_meteoro_bom
    MOV R9, 1FH
    MOV [DEF_MAX_LINHA], R9             ; voltamos a por o valor da max_linha no valor normal
    MOV R10, 40                         ; um valor qualquer acima de 32 para que o meteoro desapareca do ecra
    MOV [R7], R10                       ; atualizamos a linha do meteoro
    JMP check_rover_meteoro_ret

acaba_jogo_colisao:                     ; usado para se um metoro mau bater no rover
    MOV R3, 1
    MOV [DEF_ACABA_FLAG], R3            ; indicar ao programa que o jogo deve acabar

check_rover_meteoro_ret:                ; usado para fazer exclusivamente os POPS
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0

rover_meteoro_varios:                   ; usado para atualizar o apontador que nos indica qual é o meteoro que tamos a tratar
    MOV R2, 12
    MOV R0, [DEF_VARIOS_FLAG]
    CMP R0, R2                          ; caso o apontador ja esteja a apontar para o ultimo meteoro deve voltar para a main
    JZ termina_varios_meteoro_rover
    ADD R0, 4                           ; por o apontador a apontar para o proximo meteoro
    MOV [DEF_VARIOS_FLAG], R0
    JMP check_rover_meteoro

termina_varios_meteoro_rover:           ; usado para dar reset ao apontador e para voltar para a main
    MOV R1, 0
    MOV [DEF_VARIOS_FLAG], R1 
    RET
    

;###########################################################################################

check_missil_meteoro:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11


    MOV R7, DEF_POSICAO_METEORO
    MOV R11, [DEF_VARIOS_FLAG]          ; apontador para conseguirmos aceder ao meteoro que tamos a tratar
    ADD R7, R11                         ; agora R7 tem o endereco do meteoro atual

    MOV R1, [DEF_POSICAO_TIRO]
    MOV R2, [R7]
    ADD R2, 5
    CMP R1, R2                          ; se a linha do tiro for superior à linha do meteoro mais a sua altura (5) volta para a main, pois com certeza nao havera colisao missil-meteoro 
    JGT check_missil_meteoro_ret
    MOV R1, [DEF_POSICAO_TIRO+2]
    MOV R2, [R7+2]
    ADD R2, 5
    CMP R1, R2                          ; se a coluna do missl for maior que a coluna do meteoro mais a sua largura (5) volta para a main, pois com certeza nao havera colisao missil-meteoro
    JGT check_missil_meteoro_ret
    MOV R1, [DEF_POSICAO_TIRO+2]
    MOV R2, [R7+2]
    CMP R2, R1                          ;se a coluna do meteoro for maior que a coluna do missil volta para a main, pois com certeza nao havera colisao missil-meteoro
    JGT check_missil_meteoro_ret
    JMP colisao_bom_mau_missil

colisao_bom_mau_missil:                 ; usado para decidir se vai haver uma colisao com um meteoro bom ou com um mau
    MOV R1, [R7]                        ; R1 vai guardar a linha do meteoro
    MOV R2, [R7+2]                      ; R2 vai guardar a coluna do meteoro
    MOV R10, R2                         ; R10 vai guardar uma copia da coluna do meteoro

    MOV R3, DEF_RANDOM
    ADD R3, R11                         ; apontador para conseguirmos aceder ao meteoro que tamos a tratar
    MOV R3, [R3]
    CMP R3, 1                           ; se o meteoro for mau vamos aumentar a energia, caso contrario vamos so destruiri o bom
    JZ aumenta_energia_colisao_mau
    JMP destroi_bom

aumenta_energia_colisao_mau:
    MOV R4, [DEF_ENERGIA]
    SUB R4, 2                           ; equivale a recuar 1 word1 na tabela dos multiplos de 5 decrescentes ou seja aumentar 5 a energia
    MOV [DEF_ENERGIA], R4

    MOV R5, DEF_ENERGIA_VALORES
    ADD R5, R4
    MOV R0, DISPLAYS                    ; endereço dos displays
    MOV R6, [R5]
    MOV [R0], R6                        ; atualiza o valor da energia nos displays

    MOV R9, [R7]                        ; R7 tem o endereco do meteoro atual
    ADD R9, 1                           ; adicionar 1 na linha para quando for apagar, apagar na posicao certa
    MOV [R7], R9                        ; porque o apagar vai apagar da posicao anterior

    MOV R8, [R7]
    SUB R8, 1                           ; guardar em R8 o valor anterior à linha do meteoro
    MOV [DEF_MAX_LINHA], R8             ; alterar a max_linha para dar reset ao meteoro
    CALL apaga_meteoro_mau
    MOV R8, 1FH                         ; voltamos a por o valor da max_linha no valor normal
    MOV [DEF_MAX_LINHA], R8
    MOV R8, 40
    MOV [R7], R8                        ; alterar a linha do meteoro para 40 para ele desparacer
    JMP reset_tiro

destroi_bom:
    MOV R9, [R7]                        ; R7 tem o endereco do meteoro atual
    ADD R9, 1                           ; adicionar 1 na linha para quando for apagar, apagar na posicao certa
    MOV [R7], R9                        ; porque o apagar vai apagar da posicao anterior

    MOV R8, [R7]
    SUB R8, 1                           ; guardar em R8 o valor anterior à linha do meteoro
    MOV [DEF_MAX_LINHA], R8             ; alterar a max_linha para dar reset ao meteoro
    CALL apaga_meteoro_bom
    MOV R8, 1FH                         ; voltamos a por o valor da max_linha no valor normal
    MOV [DEF_MAX_LINHA], R8
    MOV R8, 40                          ; alterar a linha do meteoro para 40 para ele desparacer
    MOV [R7], R8

reset_tiro: 
    MOV R9, [DEF_POSICAO_TIRO]
    SUB R9, 1
    MOV [DEF_POSICAO_TIRO], R9

    MOV R8, [DEF_POSICAO_TIRO]
    ADD R8, 1
    MOV [DEF_MAX_LINHA_TIRO], R8
    CALL apaga_tiro
    MOV R8, 16
    MOV [DEF_MAX_LINHA_TIRO], R8
    MOV R8, 1BH
    MOV [DEF_POSICAO_TIRO], R8
    MOV R9, 100
    MOV [DEF_POSICAO_TIRO+2], R9 

desenha_explosao:
    MOV  R9, R10                        ; vai alterar o r10 e nos queremos guarda lo
    MOV  R8, R1                         ; vai alterar o r1 e nos queremos guarda lo
    MOV  R4, DEF_EXPLOSAO
    MOV  R5, [R4]                       ; largura
    ADD  R4, 2
    MOV  R6, [R4]                       ; altura 
    ADD  R4, 2

desenha_explosao_pixels:
    MOV  R3, [R4]                       ; obtém a cor do próximo pixel do explosao
    MOV  [DEFINE_LINHA], R1             ; seleciona a linha
    MOV  [DEFINE_COLUNA], R10           ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3             ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R4, 2                          ; endereço da cor do próximo pixel 
    ADD  R10, 1                         ; próxima coluna
    SUB  R5, 1                          ; menos uma coluna para tratar
    JNZ  desenha_explosao_pixels        ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                          ; volta a por o numero de colunas a tratar para 5
    ADD  R1, 1                          ; passa para a proxima linha
    SUB  R10, 5                         ; mete o valor da coluna atual a 0
    SUB  R6, 1                          ; diminui 1 na altura do explosao
    JNZ  desenha_explosao_pixels        ; continua até percorrer toda a altura do objeto
    JMP atraso_explosao

check_missil_meteoro_ret:               ; usado para fazer exclusivamente os POPS
    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0

missil_meteoro_varios:                  ; usado para atualizar o apontador que nos indica qual é o meteoro que tamos a tratar
    MOV R2, 12
    MOV R0, [DEF_VARIOS_FLAG]
    CMP R0, R2                          ; caso o apontador ja esteja a apontar para o ultimo meteoro deve voltar para a main
    JZ termina_varios_missil_meteoro
    ADD R0, 4                           ; por o apontador a apontar para o proximo meteoro
    MOV [DEF_VARIOS_FLAG], R0
    JMP check_missil_meteoro

termina_varios_missil_meteoro:          ; usado para dar reset ao apontador e para voltar para a main
    MOV R1, 0
    MOV [DEF_VARIOS_FLAG], R1 
    RET

atraso_explosao:
    PUSH R11
    MOV R11, ATRASO                 

ciclo_atraso_explosao:                       
    SUB R11, 1          
    JNZ ciclo_atraso_explosao
    POP R11

atraso_explosao_2:
    PUSH R11
    MOV R11, ATRASO                

ciclo_atraso_explosao_2:                       
    SUB R11, 1          
    JNZ ciclo_atraso_explosao_2
    POP R11

apaga_explosao:
    MOV  R4, DEF_EXPLOSAO
    MOV  R5, [R4]                           ; largura
    ADD  R4, 2
    MOV  R6, [R4]                           ; altura 

apaga_explosao_pixels:
    MOV  R3, 0                              ; para apagar, a cor do pixel é sempre 0
    MOV  [DEFINE_LINHA], R8                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R9                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R9, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  apaga_explosao_pixels              ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                              ; volta a por o numero de colunas a tratar para 5
    ADD  R8, 1                              ; passa para a proxima linha
    SUB  R9, 5                              ; mete o valor da coluna atual a 0
    SUB  R6, 1                              ; diminui 1 na altura do meteoro
    JNZ  apaga_explosao_pixels              ; continua até percorrer toda a altura do objeto
    JMP check_missil_meteoro_ret

;###########################################################################################

mover_meteoro:
    PUSH R0
    MOV R0, 1
    MOV [DEF_METEORO_FLAG], R0
    POP R0
    RFE

mover_energia:
    PUSH R0
    MOV R0, 1
    MOV [DEF_ENERGIA_FLAG], R0
    POP R0
    RFE

mover_tiro:
    PUSH R0
    MOV R0, 1
    MOV [DEF_TIRO_FLAG], R0
    POP R0
    RFE

;###########################################################################################