triangular(N) :- triangular(N, 1, 0).

triangular(N, _, N).

triangular(N, M, Ac) :-
    NewAc is M + Ac,
    NewM is M +1,
    NewAc =< N,
    triangular(N, NewM, NewAc).