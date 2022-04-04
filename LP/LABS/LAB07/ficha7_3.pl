repete_el(El,N,L) :-
    length(L, N),
    maplist(unifica(El), L).

unifica(X, Y) :-
    X = Y.