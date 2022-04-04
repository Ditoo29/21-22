num_occ(Lst, El, N) :-
    findall(El, member(El, Lst), Aux),
    length(Aux, N).