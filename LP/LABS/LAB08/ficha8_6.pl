soma_digitos(N, S) :- soma_digitos(N, S, 0).

soma_digitos(0,S,S).

soma_digitos(N, S, Aux) :-
    R is N mod 10,
    I is N // 10,
    Soma is Aux + R,
    soma_digitos(I, S, Soma).
