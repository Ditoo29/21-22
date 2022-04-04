duplica_elementos(L1, L2) :-
    findall([N, N], member(N, L1), Aux),
    append(Aux, L2).