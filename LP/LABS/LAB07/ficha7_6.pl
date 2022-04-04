substitui_maiores_N(N, Subst, Lst1, Lst2) :-
    maplist(substitui_maiores_Aux(N, Subst), Lst1, Lst2).
    
substitui_maiores_Aux(N, _, El, El) :-
    El =< N.

substitui_maiores_Aux(N, Sub, El, Sub) :-
    El > N.