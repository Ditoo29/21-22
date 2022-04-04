insere_ordenado(El, Lst1, Lst2) :-
    findall(X, (member(X, Lst1), X < El), Menores),
    findall(X, (member(X, Lst1), X >= El), Maiores),
    append([Menores, [El], Maiores], Lst2).

%-----------------------------------------------------------
junta_novo_aleatorio(Lst1, LI, LS, Lst2) :-
    findall(N, between(LI, LS, N), Todos),
    subtract(Todos, Lst1, Possiveis),
    length(Possiveis, L),
    random_between(1, L, R),
    nth1(R, Possiveis, El),
    insere_ordenado(El, Lst1, Lst2).
