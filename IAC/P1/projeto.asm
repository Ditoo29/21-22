; *********************************************************************************
; * Projeto IAC 2021/22 - IST-UL - Versão Intermédia
; * Alunos: Diogo Pinto(103259), Rafael Sargento(103344), Henrique Costa(103663)
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays 
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado 
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado
LINHA_TEC  EQU 1       ; linha a testar (1ª linha, 0001b)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

DEFINE_LINHA            EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA           EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL            EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO             EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ              EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo
EMITE_SOM               EQU 605AH      ; endereço do comando para reproduzir o som

MIN_COLUNA      EQU  0         ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA      EQU  59        ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA       EQU  31        ; número da linha mais a baixo que o objeto pode ocupar
ATRASO          EQU 0FFFFH     ; atraso para limitar a velocidade de movimento do boneco

LINHA_BONECO    EQU 28         ; linha default do boneco
COLUNA_BONECO   EQU 30         ; coluna default do boneco

LARGURA_BONECO    EQU 5        ; largura do boneco
ALTURA_BONECO     EQU 4        ; altura do boneco

LINHA_METEORO_MAU  EQU 0       ; linha default do meteoro mau
COLUNA_METEORO_MAU EQU 15      ; coluna default do meteoro mau

LARGURA_METEORO_MAU    EQU 5   ; largura do meteoro mau
ALTURA_METEORO_MAU     EQU 5   ; altura do meteoro mau

TECLA EQU -1                   ; valor inicial do valor da tecla (calculado entre 0 e F quando pressionada)
LARGA EQU -1                   ; valor inicial de uma constante que analiza se a tecla foi largada

ENERGIA EQU 0                  ; valor inicial da Energia do Rover

LINHA_TECLA EQU -1             ; reset à linha das teclas, no teclado

COR_PIXEL_AMARELO   EQU 0FFF0H ; cor do pixel: amarelo em ARGB 
COR_PIXEL_VERMELHO  EQU 0FF00H ; cor do pixel: vermelho em ARGB 
                        
FLAG EQU 0                     ; valor inicial da flag que sinaliza o acontecimento da rotina meteoro_mau_init

; #######################################################################
; * ZONA DE DADOS 
; #######################################################################
PLACE       0300H               

DEF_INIT:                   ; WORD que verifica se o meteoro mau já foi iniciado (meteoro_mau_init)
    WORD                    FLAG

DEF_BONECO:                 ; tabela que define o boneco (cor, largura, altura, pixels)      
    WORD                    LARGURA_BONECO
    WORD                    ALTURA_BONECO

    WORD                    0, 0, COR_PIXEL_AMARELO, 0, 0       
    WORD                    COR_PIXEL_AMARELO, 0, COR_PIXEL_AMARELO, 0, COR_PIXEL_AMARELO     
    WORD                    COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO       
    WORD                    0, COR_PIXEL_AMARELO, 0, COR_PIXEL_AMARELO, 0      

DEF_POSICAO_BONECO:         ; tabela que define a posição do boneco
    WORD                    LINHA_BONECO
    WORD                    COLUNA_BONECO

DEF_METEORO_MAU:            ; tabela que define o meteoro mau (cor, largura, altura, pixels) 
    WORD                    LARGURA_METEORO_MAU
    WORD                    ALTURA_METEORO_MAU

    WORD                    COR_PIXEL_VERMELHO, 0, 0, 0, COR_PIXEL_VERMELHO      
    WORD                    COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO       
    WORD                    0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0      
    WORD                    COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO       
    WORD                    COR_PIXEL_VERMELHO, 0, 0, 0, COR_PIXEL_VERMELHO    

DEF_POSICAO_METEORO_MAU:    ; tabela que define a posição do meteoro mau
    WORD                    LINHA_METEORO_MAU
    WORD                    COLUNA_METEORO_MAU

DEF_TECLA:                  ; tabela que regista o valor da tecla pressionada e se a mesma foi largada
    WORD                    TECLA
    WORD                    LARGA

DEF_ENERGIA:                ; WORD que define a energia do rover
    WORD                    ENERGIA

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE      0
energia_init:
    MOV R10, 0
    MOV [DEF_ENERGIA], R10              ; inicializar a energia do rover a 0
    MOV R0, [DEF_ENERGIA]               ; associar a energia do rover ao registo R0
    MOV R1, DISPLAYS                    ; associar o registo R1 ao endereço dos displays
    MOV [R1], R0                        ; escrever nos displays a energia a 0

boneco_init:
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
    MOV  R10, 0
    MOV  [DEF_INIT], R10                ; inicializa a flag que simboliza a passagem pelo meteoro_mau_init a 0
    JMP  desenha_boneco                 ; procede a desenhar o boneco incial

meteoro_mau_init:
    MOV  R1, LINHA_METEORO_MAU          ; associa a linha inicial do meteoro mau a R1
    MOV  R2, COLUNA_METEORO_MAU         ; associa a coluna inicial do meteoro mau a R2
    MOV  R8, DEF_POSICAO_METEORO_MAU    ; associa R8 à memória da posição do meteoro mau (neste caso linha)
    MOV  [R8], R1                       ; inicializa a linha do meteoro mau com o valor inicial previamente definido
    ADD  R8, 2                          ; associa R8 à memória da coluna do meteoro mau
    MOV  [R8], R2                       ; inicializa a coluna do meteoro mau com o valor inicial previamente definido 
    JMP desenha_meteoro_mau             ; procede a desenhar o meteoro mau incial


;###########################################################################################

main:                                   ;rotina mãe que controla o programa inteiro
    JMP teclado
    boneco:
        JMP apaga_boneco
    meteoro_mau:
        JMP apaga_meteoro_mau


;###########################################################################################

teclado:
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
                       

transforma_linha_tecla:                 ; este ciclo vai transformar o número da linha 1,2,4,8  em 0,1,2,3
    SHR R1, 1                           ; andar 1 para trás na ordem 1,2,4,8
    CMP R1, 0              
    JNZ transforma_linha_tecla_aux
    JMP transforma_coluna_tecla

transforma_coluna_tecla:    
    SHR R0, 1                           ; este ciclo vai transformar o número da coluna 1,2,4,8  em 0,1,2,3
    CMP R0, 0                           ; andar 1 para trás na ordem 1,2,4,8
    JNZ transforma_coluna_tecla_aux

valor_tecla:
    MOV R10, [DEF_TECLA + 2]            ; valor usado para o meteoro só descer uma linha quando se pressiona a tecla
    MUL R7, R9                          ; multiplica o valor da linha por 4 (valor guardado em R9)
    ADD R7, R8                          ; guarda no R7 o resultado da formula 4*linha + coluna
    MOV [DEF_TECLA], R7                 ; guarda em memória o valor da tecla
    CMP R7, 0                                
    JZ boneco
    CMP R7, 2
    JZ boneco
    CMP R7, 4
    JZ diminui_energia
    CMP R7, 5
    JZ adiciona_energia
    CMP R10, 0                          ; sempre que alguma tecla está a ser pressionada continuamente este valor está a 0
    JZ main                     
    CMP R7, 3                  
    JZ faz_som                          ; só vai para o ciclo faz_som se tiver a carregar na tecla 3 sem ser continuamente
    JMP main

transforma_linha_tecla_aux:             ; ciclo usado para saber quantas vezes foram necessárias SHR, para chegar a 0
    ADD R7, 1                           ; no fim do ciclo fica no R7 o valor da linha
    JMP transforma_linha_tecla

transforma_coluna_tecla_aux:            ; ciclo usado para saber quantas vezes foram necessárias SHR, para chegar a 0
    ADD R8, 1                           ; no fim do ciclo fica no R8 o valor da coluna
    JMP transforma_coluna_tecla

teste_tecla:
    CMP R6, 7                           ; verifica se chegámos a ultima linha a testar
    JGT reset_tecla 
    SHL R6, 1                           ; passa para a próxima linha a testar
    JMP espera_tecla

reset_tecla:                            ; ciclo para voltarmos a por a linha a ser testada a 1
    MOV R10, -1
    MOV [DEF_TECLA + 2], R10            ; quando nenhuma tecla está a ser pressionada este valor está a -1
    MOV R6, LINHA_TEC                   ; mete a linha a ser testada a 1
    JMP espera_tecla

;###########################################################################################

desenha_boneco:
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

check_init_boneco:
    MOV R8, DEF_INIT                ; associa R8 à WORD que verifica se o meteoro_mau_init já foi executado
    MOV R11, [R8]                   ; move o valor da FLAG para R11
    CMP R11, 0                      
    JNZ pre_atraso                  ; se a comparação não der 0, meteoro_mau_init já foi executado, logo segue para o ciclo de ataso (e posteriormente main)
    ADD R11, 1                      ; se não, altera o valor do R11 para 1
    MOV [DEF_INIT], R11             ; e guarda esse valor na FLAG, alterando-a
    JMP meteoro_mau_init            ; por fim, executa o meteoro_mau_init

pre_atraso:
    MOV R11, ATRASO                 ; atraso para limitar a velocidade de movimento do boneco

ciclo_atraso:                       ; ciclo responsável por atrasar velocidade do boneco
    SUB R11, 1          
    JNZ ciclo_atraso
    JMP main
    
    
apaga_boneco:                       ; apaga o boneco a partir da tabela
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
    MOV  R3, 0                      ; cor para apagar pixel
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
    JMP desenha_boneco              ; se não for nenhuma das teclas desenhamos o boneco na mesma posição

coluna_anterior:                    ; ciclo responsável por mover boneco para a esquerda
    CMP R2, MIN_COLUNA              ; se o boneco tocar na borda lateral esquerda deve ser desenhado na mesma posição,
    JZ desenha_boneco               ; não atravessando a parede
    ADD R2, -1                      ; se não estiver a tocar no limite lateral podemos mudar a coluna do boneco 1 pixel para a esquerda
    MOV [R8], R2                    ; atualizamos valor da coluna atual do boneco
    JMP desenha_boneco              ; alterando a coluna para o onde o queremos desenhar só falta desenhar

coluna_posterior:                   ; ciclo responsável por mover boneco para a direita
    MOV R10, MAX_COLUNA             ; se o boneco tocar na borda lateral direita deve ser desenhado na mesma posição,
    CMP R2, R10                     ; não atravessando a parede
    JZ desenha_boneco
    ADD R2, 1                       ; se não estiver a tocar no limite lateral podemos mudar a coluna do boneco 1 pixel para a direita
    MOV [R8], R2                    ; atualizamos valor da coluna atual do boneco
    JMP desenha_boneco              ; alterando a coluna para o onde o queremos desenhar só falta desenhar

;###########################################################################################

diminui_energia:
    MOV R0, [DEF_ENERGIA]   ; valor atual da energia
    SUB R0, 1               ; diminui em 1 o valor atual da energia
    MOV [DEF_ENERGIA], R0   ; atualiza o valor atual da energia
    JMP adiciona_display    ; vai para o ciclo que coloca o valor da energia atualizado nos displays

adiciona_energia:
    MOV R0, [DEF_ENERGIA]   ; valor atual da energia
    ADD R0, 1               ; aumenta em 1 o valor atual da energia
    MOV [DEF_ENERGIA], R0   ; atualiza o valor atual da energia

adiciona_display:           ; coloca a energia atualizada nos displays
    MOV R1, DISPLAYS        ; endereço dos displays
    MOV [R1], R0            ; atualiza o valor da energia nos displays
    JMP pre_atraso          ; volta para o ciclo de atraso

;###########################################################################################

faz_som:                              
    MOV R1, 0
    MOV [DEF_TECLA + 2], R1                 ; mete a 0 que indica que a tecla 3 esta a ser pressionada
    MOV [EMITE_SOM], R1                     ; comando para emitir o som
    JMP apaga_meteoro_mau

desenha_meteoro_mau:
    MOV R8, DEF_POSICAO_METEORO_MAU              
    MOV R1, [R8]                            ; obtém a linha do meteoro    
    ADD R8, 2
    MOV R2, [R8]                            ; obtém a coluna do meteoro
    MOV R6, R1                              ; cópia da linha do meteoro
    MOV R4, DEF_METEORO_MAU                 ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    ADD R4, 2
    MOV R7, [R4]                            ; obtém a altura do meteoro
    ADD R4, 2               


desenha_pixels_meteoro_mau:                 ; desenha os pixels do meteoro a partir da tabela
    MOV  R3, [R4]                           ; obtém a cor do próximo pixel do meteoro
    MOV  [DEFINE_LINHA], R6                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R4, 2                              ; endereço da cor do próximo pixel 
    ADD  R2, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  desenha_pixels_meteoro_mau         ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                              ; volta a por o numero de colunas a tratar para 5
    ADD  R6, 1                              ; passa para a próxima linha
    SUB  R2, 5                              ; mete o valor da coluna atual a 0
    SUB  R7, 1                              ; diminui 1 na altura do meteoro
    JNZ  desenha_pixels_meteoro_mau         ; continua até percorrer toda a altura do objeto
    JMP  pre_atraso             

apaga_meteoro_mau:               
    MOV R8, DEF_POSICAO_METEORO_MAU               
    MOV R1, [R8]                            ; valor da linha do meteoro mau
    ADD R8, 2                               
    MOV R2, [R8]                            ; valor da coluna do meteoro mau
    MOV R6, R1                              ; cópia da linha do meteoro
    MOV R4, DEF_METEORO_MAU                 ; endereço da tabela que define o meteoro
    MOV R5, [R4]                            ; obtém a largura do meteoro
    ADD R4, 2
    MOV R7, [R4]                            ; obtém a altura do meteoro

apaga_pixels_meteoro_mau:               
    MOV  R3, 0                              ; cor para apagar pixel
    MOV  [DEFINE_LINHA], R6                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  apaga_pixels_meteoro_mau           ; continua até percorrer toda a largura do objeto
    MOV  R5, 5                              ; volta a por o número de colunas a tratar para 5
    ADD  R6, 1                              ; passa para a próxima linha
    SUB  R2, 5                              ; mete o valor da coluna atual a 0
    SUB  R7, 1                              ; diminui 1 na altura do meteoro
    JNZ  apaga_pixels_meteoro_mau           ; continua até percorrer toda a altura do objeto


linha_seguinte:
    MOV R10, MAX_LINHA                      ; associa o valor da linha máxima ao R10
    CMP R1, R10                             ; compara o valor da linha máxima com a linha atual
    JZ pre_atraso                           ; se o resultado for 0, volta para a main, apenas apagando o meteoro (saiu do ecrã)
    ADD R1, 1                               ; se não, passa para a próxima linha
    SUB R8, 2                               
    MOV [R8], R1                            ; guarda o valor da nova linha na memória
    JMP desenha_meteoro_mau                 ; procede a desenhar o meteoro na nova posição

;###########################################################################################