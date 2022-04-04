inverte(N, Inv) :- inverte(N, Inv, 0).

inverte(0, Inv, Inv).

inverte(N, Inv, Aux) :-
    R is N mod 10,
    I is N // 10,
    Inverte is Aux*10 + R,
    inverte(I, Inv, Inverte).