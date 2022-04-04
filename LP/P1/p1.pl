% Diogo Pinto | No 103259 | LEIC-T | Logica da Programacao | Prof Luisa Coheur | 2021/22
:- [codigo_comum].

%---------------------------------------------------------------------------------------------------------------------
% extrai_ilhas_linha(N_L, Linha, Ilhas)

/*
Este predicado assume 3 variaveis, sendo N_L um inteiro positivo, Linha que corresponde a uma ilha do puzzle, e Ilhas que corresponde as ilhas presentes nessa mesma linha.
O objetivo deste predicado e extrair todas as ilhas presentes numa dada Linha do Puzzle.
*/

extrai_ilhas_linha(N_L, Linha, Ilhas) :- extrai_ilhas_linha(N_L, Linha, Ilhas, [], 1). % resolvido atraves de iteracao

extrai_ilhas_linha(_, [], Ilhas, Ilhas, _).

extrai_ilhas_linha(N_L, [Ca|Re], Ilhas, Aux, Inc) :-
    Ca > 0,
    append(Aux, [ilha(Ca, (N_L, Inc))], NewAux),
    Inc_N is Inc + 1,
    extrai_ilhas_linha(N_L, Re, Ilhas, NewAux, Inc_N).
    

extrai_ilhas_linha(N_L, [Ca|Re], Ilhas, Aux, Inc) :-
    Ca == 0,
    Inc_N is Inc + 1,
    extrai_ilhas_linha(N_L, Re, Ilhas, Aux, Inc_N).

%---------------------------------------------------------------------------------------------------------------------
% ilhas(Puz, Ilhas)

/*
Este predicado assume 2 variaveis, sendo Puz um puzzle e Ilhas todos os elementos do puzzle que correspondem a ilhas.
O objetivo deste predicado e extrair todas as ilhas presentes num Puzzle recorrendo a funcao definida extrai_ilhas_linha/3.
*/

ilhas(Puz, Ilhas) :- ilhas(Puz, Ilhas, [], 1). % resolvido atraves de iteracao

ilhas([], Ilhas, Ilhas, _).

ilhas([Ca|Re], Ilhas, Aux, Inc) :-
    extrai_ilhas_linha(Inc, Ca, Ilhas_N),
    append(Aux, Ilhas_N, NewAux),
    Inc_N is Inc + 1, 
    ilhas(Re, Ilhas, NewAux, Inc_N).

%---------------------------------------------------------------------------------------------------------------------
% vizinhas(Ilhas, Ilha, Vizinhas)

/*
Este predicado assume 3 variaveis, sendo Ilhas as ilhas de um Puzzle, Ilha uma dessas ilhas e Vizinhas a lista das vizinhas dessa mesma ilha.
O objetivo deste predicado e extrair todas as vizinhas da Ilha dada.
*/

%-------------------------------------------------Funcao Auxiliar-----------------------------------------------------
% Para resolver este exercicio recorri ao uso de 4 funcoes auxiliares, que me ajudam a encontrar a vizinha da ilha em questao nas 4 direcoes possiveis (cada uma analisa uma das direcoes).

vizinhas_c(Ilhas, ilha(P, (X, Y)), Aux1) :-
    findall(ilha(P2, (X2, Y)), member(ilha(P2, (X2, Y)), Ilhas), Saco2),
    nth1(Ind, Saco2, ilha(P, (X, Y))),
    C is Ind - 1,
    nth1(C, Saco2, Cc) ->
    Aux1 = [Cc];
    Aux1 = [].

vizinhas_e(Ilhas, ilha(P, (X, Y)), Aux2) :-
    findall(ilha(P2, (X, Y2)), member(ilha(P2, (X, Y2)), Ilhas), Saco1),
    nth1(Ind, Saco1, ilha(P, (X, Y))),
    E is Ind - 1,
    nth1(E, Saco1, Ee) ->
    Aux2 = [Ee];
    Aux2 = [].

vizinhas_d(Ilhas, ilha(P, (X, Y)), Aux3) :-
    findall(ilha(P2, (X, Y2)), member(ilha(P2, (X, Y2)), Ilhas), Saco1),
    nth1(Ind, Saco1, ilha(P, (X, Y))),
    D is Ind + 1,
    nth1(D, Saco1, Dd) ->
    Aux3 = [Dd];
    Aux3 = [].

vizinhas_b(Ilhas, ilha(P, (X, Y)), Aux4) :-
    findall(ilha(P2, (X2, Y)), member(ilha(P2, (X2, Y)), Ilhas), Saco2),
    nth1(Ind, Saco2, ilha(P, (X, Y))),
    B is Ind + 1,
    nth1(B, Saco2, Bb) ->
    Aux4 = [Bb];
    Aux4 = [].

%-------------------------------------------------Funcao Auxiliar-----------------------------------------------------
% Na funcao principal utilizo todas as funcoes definidas previamente e junto todas as vizinhas que foram encontradas. 

vizinhas(Ilhas, ilha(P, (X, Y)), Vizinhas) :-
    vizinhas_c(Ilhas, ilha(P, (X, Y)), Aux1),
    vizinhas_e(Ilhas, ilha(P, (X, Y)), Aux2),
    vizinhas_d(Ilhas, ilha(P, (X, Y)), Aux3),
    vizinhas_b(Ilhas, ilha(P, (X, Y)), Aux4),
    append([Aux1, Aux2, Aux3, Aux4], Vizinhas).

%---------------------------------------------------------------------------------------------------------------------
% estado(Ilhas, Estado)

/*
Este predicado assume 2 variaveis, sendo Ilhas e a lista de ilhas de um Puzzle e Estado a lista ordenada de Entradas dessas mesmas ilhas.
O objetivo deste predicado e extrair o estado de um puzzle, atraves das suas diversas entradas. 
Uma entrada defini-se por:
O 1o elemento e uma ilha
O 2o elemento e a lista de vizinhas dessa ilha
O 3o elemento e a lista de pontes de uma ilha
*/

estado(Ilhas, Estado) :- estado(Ilhas, Ilhas, Estado, []). % resolvido atraves de iteracao

estado([], _, Estado, Estado).

estado([Ca|Re], Ilhas, Estado, Aux) :-
    vizinhas(Ilhas, Ca, Vizinhas),
    append(Aux, [[Ca, Vizinhas, []]], NewAux),
    estado(Re, Ilhas, Estado, NewAux).

%---------------------------------------------------------------------------------------------------------------------
% posicoes_entre(Pos1, Pos2, Posicoes) 

/*
Este predicado assume 3 variaveis, sendo Pos1 e Pos2 posicoes e Posicoes as Posicoes entre Pos1 e Pos2. 
O objetivo deste predicado e extrair todas as Posicoes entre Pos1 e Pos2.
*/

posicoes_entre((X, Y), (X2, Y2), Posicoes) :- posicoes_entre((X, Y), (X2, Y2), Posicoes, []). % resolvido atraves de iteracao

posicoes_entre((X, Y), (X, Y), Posicoes, Posicoes).

%-------------------------------------------------Parte Final-------------------------------------------------------
% Verifica, para cada caso, o tamanho da lista Auxiliar, de modo a perceber se esta ja tem os elementos entre das duas posicoes, posteriormente verificando se a diferenca entre o elemento final
% e 1, assumindo a condicao de paragem e terminando a iteracao. Se por acaso a lista for vazia ou a diferenca entre o ultimo e penultimo membro nao for 1, o codigo continua.

posicoes_entre((X, Y), (_, Y2), Posicoes, Aux) :-
    length(Aux, L),
    L \== 0,
    Z is Y2 - Y,
    Z == 1,
    posicoes_entre((X, Y), (X, Y), Posicoes, Aux).

posicoes_entre((X, Y), (_, Y2), Posicoes, Aux) :-
    length(Aux, L),
    L \== 0,
    Z is Y - Y2,
    Z == 1,
    posicoes_entre((X, Y), (X, Y), Posicoes, Aux).

posicoes_entre((X, Y), (X2, _), Posicoes, Aux) :-
    length(Aux, L),
    L \== 0,
    Z is X2 - X,
    Z == 1,
    posicoes_entre((X, Y), (X, Y), Posicoes, Aux).

posicoes_entre((X, Y), (X2, _), Posicoes, Aux) :-
    length(Aux, L),
    L \== 0,
    Z is X - X2,
    Z == 1,
    posicoes_entre((X, Y), (X, Y), Posicoes, Aux).

%-------------------------------------------------Parte Inicial---------------------------------------------------------
% Itera, em cada caso a posicao seguinte adicionando-a a uma lista Auxiliar que sera posteriormente verificada.
% Nota: Deixei a Parte Inicial no fim pois convem a verificacao de cada lista ser feita no inicio para o codigo correr como deve ser. 

posicoes_entre((X, Y), (X2, Y2), Posicoes, Aux) :-
    X == X2,
    Y + 1 < Y2,
    Yy is Y + 1,
    append(Aux, [(X, Yy)], NewAux),
    posicoes_entre((X, Yy), (X, Y2), Posicoes, NewAux).

posicoes_entre((X, Y), (X2, Y2), Posicoes, Aux) :-
    X == X2,
    Y > Y2 + 1,
    Yy is Y2 + 1,
    append(Aux, [(X, Yy)], NewAux),
    posicoes_entre((X, Y), (X2, Yy), Posicoes, NewAux).

posicoes_entre((X, Y), (X2, Y2), Posicoes, Aux) :-
    Y == Y2,
    X + 1 < X2,
    Xx is X + 1,
    append(Aux, [(Xx, Y)], NewAux),
    posicoes_entre((Xx, Y), (X2, Y2), Posicoes, NewAux).

posicoes_entre((X, Y), (X2, Y2), Posicoes, Aux) :-
    Y == Y2,
    X > X2 + 1,
    Xx is X2 + 1,
    append(Aux, [(Xx, Y)], NewAux),
    posicoes_entre((X, Y), (Xx, Y2), Posicoes, NewAux).

%---------------------------------------------------------------------------------------------------------------------
% cria_ponte(Pos1, Pos2, Ponte)

/*
Este predicado assume 3 variaveis, sendo Pos1 e Pos2 posicoes e Ponte a ponte criada entre Pos1 e Pos2.
O objetivo deste predicado e criar a ponte entre as duas posicoes dadas.
*/

cria_ponte([], [], Ponte, Ponte).

cria_ponte((X, Y), (X2, Y2), Ponte) :- 
    X == X2, 
    Y < Y2,
    cria_ponte([], [], Ponte, ponte((X, Y), (X2, Y2))).

cria_ponte((X, Y), (X2, Y2), Ponte) :- 
    X == X2, 
    Y > Y2,
    cria_ponte([], [], Ponte, ponte((X, Y2), (X2, Y))).

cria_ponte((X, Y), (X2, Y2), Ponte) :- 
    X < X2, 
    Y == Y2,
    cria_ponte([], [], Ponte, ponte((X, Y), (X2, Y2))).

cria_ponte((X, Y), (X2, Y2), Ponte) :- 
    X > X2, 
    Y == Y2,
    cria_ponte([], [], Ponte, ponte((X2, Y), (X, Y2))).

%---------------------------------------------------------------------------------------------------------------------
% caminho_livre(Pos1, Pos2, Posicoes, I, Vz)

/*
Este predicado assume 5 variaveis, sendo Pos1 e Pos2 posicoes, Posicoes as posicoes entre Pos1 e Pos2, I uma Ilha e Vz uma das suas Vizinhas.
O objetivo deste predicado e analisar se o caminho entre I e Vz e livre apos a insercao de uma ponte entre Pos1 e Pos2.
*/

caminho_livre(Pos1, Pos2, Posicoes, ilha(_, (X, Y)), ilha(_, (X2, Y2))) :- 
    posicoes_entre((X,Y), (X2,Y2), P),
    caminho_livre(Pos1, Pos2, Posicoes, ilha(_, (X, Y)), ilha(_, (X2, Y2)), P).

caminho_livre(_, _, [], _, _, _).

caminho_livre(Pos1, Pos2, Posicoes, ilha(_, Pos1), ilha(_, Pos2), P) :- 
    Posicoes == P.

caminho_livre(Pos1, Pos2, Posicoes, ilha(_, Pos2), ilha(_, Pos1), P) :- 
    Posicoes == P.

caminho_livre(Pos1, Pos2, [Ca|Re], ilha(_, (X, Y)), ilha(_, (X2, Y2)), P) :- 
    \+member(Ca, P),
    caminho_livre(Pos1, Pos2, Re, ilha(_, (X, Y)), ilha(_, (X2, Y2)), P).

%---------------------------------------------------------------------------------------------------------------------
% actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada, Nova_Entrada)

/*
Este predicado assume 5 variaveis, sendo Pos1 e Pos2 posicoes, Posicoes as posicoes entre Pos1 e Pos2, Entrada e uma entrada e Nova_Entrada e a entrada apos a insercao da ponte entre Pos1 e Pos2.
O objetivo deste predicado e analisar as vizinhas apos a insercao da ponte, devolvendo a nova entrada.
*/

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Vizinhas, Vazio], Nova_Entrada) :-
    findall(Viz, (member(Viz, Vizinhas), caminho_livre(Pos1, Pos2, Posicoes, Ilha, Viz)), Saco),
    append([[Ilha], [Saco], [Vazio]], Nova_Entrada).

%---------------------------------------------------------------------------------------------------------------------
% actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado)

/*
Este predicado assume 4 variaveis, sendo Pos1 e Pos2 posicoes, Estado um estado e Novo_Estado e o estado apos a insercao de uma ponte entre Pos1 e Pos2.
O objetivo deste predicado e analisar e alterar cada entrada apos a insercao da ponte, devolvendo o novo estado.
*/

actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) :- actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado, []). % resolvido atraves de iteracao

actualiza_vizinhas_apos_pontes([], _, _, Novo_estado, Novo_estado).

actualiza_vizinhas_apos_pontes([Ca|Re], Pos1, Pos2, Novo_estado, Aux) :-
    posicoes_entre(Pos1, Pos2, Posicoes),
    actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Ca, Entrada),
    append(Aux, [Entrada], NewAux),
    actualiza_vizinhas_apos_pontes(Re, Pos1, Pos2, Novo_estado, NewAux).

%---------------------------------------------------------------------------------------------------------------------
% ilhas_terminadas(Estado, Ilhas_term)

/*
Este predicado assume 2 variaveis, sendo Estado um estado e Ilhas_Term as ilhas terminadas desse mesmo estado.
O objetivo deste predicado e analisar quais sao as ilhas terminadas. Uma ilha terminada e uma ilha que ja tem todas as suas pontes devidamente associadas.
*/

ilhas_terminadas(Estado, Ilhas_term) :- ilhas_terminadas(Estado, Ilhas_term, []). % resolvido atraves de iteracao

ilhas_terminadas([], Ilhas_term, Ilhas_term).

ilhas_terminadas([[ilha(N_pontes, Pos), _, Pontes]|Re], Ilhas_term, Aux) :-
    length(Pontes, Len),
    Len == N_pontes ->
    append(Aux, [ilha(N_pontes, Pos)], NewAux),
    ilhas_terminadas(Re, Ilhas_term, NewAux);
    ilhas_terminadas(Re, Ilhas_term, Aux).

%---------------------------------------------------------------------------------------------------------------------
% tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)

/*
Este predicado assume 3 variaveis, sendo Ilhas_term a lista de Ilhas terminadas, Entrada uma entrada e Nova entrada e a entrada resultante de remover as ilhas terminadas das vizinhas da ilha de entrada.
O objetivo deste predicado e analisar e retirar as ilhas terminadas das vizinhas da ilha de entrada, devolvendo a entrada finalizada apos esse processo.
*/

tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizinhas, Pontes], Nova_Entrada) :-
    findall(El, (member(El, Vizinhas), \+member(El, Ilhas_term)), Saco),
    append([[Ilha], [Saco], [Pontes]], Nova_Entrada).

%---------------------------------------------------------------------------------------------------------------------
% tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado)

/*
Este predicado assume 3 variaveis, sendo Ilhas_term a lista de Ilhas terminadas, Estado um estado e novo Estado e o estado resultante de remover as ilhas terminadas das vizinhas de todas as ilhas do estado.
O objetivo deste predicado e analisar e retirar as ilhas terminadas das vizinhas de todas as ilhas do estado, devolvendo o estado finalizado apos esse processo.
*/

tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :- tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado, []). % resolvido atraves de iteracao

tira_ilhas_terminadas([], _, Novo_estado, Novo_estado).

tira_ilhas_terminadas([Ca|Re], Ilhas_term, Novo_estado, Aux) :-
    tira_ilhas_terminadas_entrada(Ilhas_term, Ca, Nova_Entrada),
    append(Aux, [Nova_Entrada], NewAux),
    tira_ilhas_terminadas(Re, Ilhas_term, Novo_estado, NewAux).

%---------------------------------------------------------------------------------------------------------------------
% marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)

/*
Este predicado assume 3 variaveis, sendo Ilhas_term a lista de Ilhas terminadas, Entrada uma entrada e Nova entrada e a entrada resultante de marcar o numero de pontes das ilhas terminadas com um "X".
O objetivo deste predicado e analisar e marcar o numero de pontes das ilhas terminadas com um "X", devolvendo a entrada finalizada apos esse processo.
*/

marca_ilhas_terminadas_entrada(Ilhas_term, [ilha(N_pontes, Pos), Vizinhas, Pontes], Nova_entrada) :- 
    member(ilha(N_pontes, Pos), Ilhas_term) ->
    append([[ilha('X', Pos)], [Vizinhas], [Pontes]], Nova_entrada);
    append([[ilha(N_pontes, Pos)], [Vizinhas], [Pontes]], Nova_entrada).

%---------------------------------------------------------------------------------------------------------------------
% marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado)

/*
Este predicado assume 3 variaveis, sendo Ilhas_term a lista de Ilhas terminadas, Estado um estado e Novo Estado e a estado resultante de marcar o numero de pontes de todas as ilhas terminadas do estado com um "X".
O objetivo deste predicado e analisar e marcar o numero de pontes de todas as ilhas terminadas do estado com um "X", devolvendo o estado finalizado apos esse processo.
*/

marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :- marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado, []). % resolvido atraves de iteracao

marca_ilhas_terminadas([], _, Novo_estado, Novo_estado).

marca_ilhas_terminadas([Ca|Re], Ilhas_term, Novo_estado, Aux) :-
    marca_ilhas_terminadas_entrada(Ilhas_term, Ca, Nova_entrada),
    append(Aux, [Nova_entrada], NewAux),
    marca_ilhas_terminadas(Re, Ilhas_term, Novo_estado, NewAux).

%---------------------------------------------------------------------------------------------------------------------
% trata_ilhas_terminadas(Estado, Novo_estado)

/*
Este predicado assume 2 variaveis, sendo Estado um estado e Novo_Estado o estado resultante de tirar e marcar todas as ilhas terminadas do estado inicial.
O objetivo deste predicado e analisar, tirar e marcar todas as ilhas terminadas do estado inicial, devolvendo o Novo_Estado. 
*/

trata_ilhas_terminadas(Estado, Novo_Novo_estado) :- 
    ilhas_terminadas(Estado, Ilhas_term),
    tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado),
    marca_ilhas_terminadas(Novo_estado, Ilhas_term, Novo_Novo_estado).

%---------------------------------------------------------------------------------------------------------------------
% junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, Novo_estado)

/*
Este predicado assume 5 variaveis, sendo Estado um estado, Num_pontes o numero de pontes a adicionar a uma ilha, Ilha1 e Ilha2 sao ilhas e, por fim, Novo_estado 
e o resultante de aplicar este predicado a estado executando os seguintes passos:
- Cria as pontes entre Ilha1 e Ilha2
- Adiciona as novas pontes as entradas de Estado correspondentes a estas ilhas
- Atualiza o estado por aplicacao dos predicados actualiza_vizinhas_apos_pontes e trata_ilhas_terminadas
*/

junta_pontes(Estado, Num_pontes, ilha(_, Pos1), ilha(_, Pos2), Novo_estado) :-
    cria_ponte(Pos1, Pos2, Ponte),
    adiciona_ponte(Estado, Ponte, N_Estado1, Num_pontes),
    actualiza_vizinhas_apos_pontes(N_Estado1, Pos1, Pos2, N_Estado2),
    trata_ilhas_terminadas(N_Estado2, Novo_estado).

%-------------------------------------------------Funcao Auxiliar-----------------------------------------------------
% Esta funcao auxiliar adiciona as pontes necessarias a um entrada, devolvendo a entrada com as pontes associadas.

adiciona_ponte_entrada([ilha(N_pontes, Pos), Vizinhas, Pontes], Ponte, Nova_entrada, Num_pontes) :-
    Num_pontes == 1 ->
    append(Pontes, [Ponte], Nova_pontes),
    append([[ilha(N_pontes, Pos)], [Vizinhas], [Nova_pontes]], Nova_entrada);
    append(Pontes, [Ponte, Ponte], Nova_pontes),
    append([[ilha(N_pontes, Pos)], [Vizinhas], [Nova_pontes]], Nova_entrada).

%-------------------------------------------------Funcao Auxiliar-----------------------------------------------------
% Esta funcao auxiliar faz a verificacao das ilhas que necessitam ter pontes associadas e junta-as utilizando a funcao adiciona_ponte_entrada definida anteriormente.

adiciona_ponte(Estado, Ponte, Novo_estado, Num_pontes) :- adiciona_ponte(Estado, Ponte, Novo_estado, [], Num_pontes).

adiciona_ponte([], _, Novo_estado, Novo_estado, _).

adiciona_ponte([[ilha(N_pontes, Pos), Vizinhas, Pontes]|Re], ponte(Pos1, Pos2), Novo_estado, Aux, Num_pontes) :-
    Pos == Pos1,
    adiciona_ponte_entrada([ilha(N_pontes, Pos), Vizinhas, Pontes], ponte(Pos1, Pos2), Nova_entrada, Num_pontes),
    append(Aux, [Nova_entrada], NewAux),
    adiciona_ponte(Re, ponte(Pos1, Pos2), Novo_estado, NewAux, Num_pontes).

adiciona_ponte([[ilha(N_pontes, Pos), Vizinhas, Pontes]|Re], ponte(Pos1, Pos2), Novo_estado, Aux, Num_pontes) :-
    Pos == Pos2,
    adiciona_ponte_entrada([ilha(N_pontes, Pos), Vizinhas, Pontes], ponte(Pos1, Pos2), Nova_entrada, Num_pontes),
    append(Aux, [Nova_entrada], NewAux),
    adiciona_ponte(Re, ponte(Pos1, Pos2), Novo_estado, NewAux, Num_pontes).

adiciona_ponte([[ilha(N_pontes, Pos), Vizinhas, Pontes]|Re], ponte(Pos1, Pos2), Novo_estado, Aux, Num_pontes) :-
    append(Aux, [[ilha(N_pontes, Pos), Vizinhas, Pontes]], NewAux),
    adiciona_ponte(Re, ponte(Pos1, Pos2), Novo_estado, NewAux, Num_pontes).

%-------------------------------------------------Funcao Auxiliar-----------------------------------------------------