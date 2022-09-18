def vetor(x, y):
    if type(x) not in (int, float) or type(y) not in (int, float):
        raise ValueError("Invalido")
    return x, y


def abcissa(v):
    return v[0]


def ordenada(v):
    return v[1]


def eh_vetor(arg):
    return type(arg[0]) in (int, float) and type(arg[1]) in (int, float) and type(arg) == tuple and len(arg) == 2


def eh_vetor_nulo(v):
    return eh_vetor(v) and abcissa(v) == 0 and ordenada(v) == 0


def vetores_iguais(v1, v2):
    return eh_vetor(v1) and eh_vetor(v2) and abcissa(v1) == abcissa(v2) and ordenada(v1) == ordenada(v2)


def produto_escalar(v1, v2):
    if not all(eh_vetor(v1) or eh_vetor(v2)):
        raise ValueError("Invalido")
    return abcissa(v1) * abcissa(v2) + ordenada(v1) * ordenada(v2)
