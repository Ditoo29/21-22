def soma_els_atomicos(t):
    if len(t) == 0:
        return 0
    if type(t[0]) == tuple:
        return soma_els_atomicos(t[0]) + soma_els_atomicos(t[1:])
    else:
        return t[0] + soma_els_atomicos(t[1:])


print(soma_els_atomicos((3, ((((((6, (7,))),),),),), 2, 1)))
