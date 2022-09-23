from functools import reduce


def lista_digitos(n):
    return list(map(lambda x: int(x), str(n)))


def produto_digitos(n, pred):
    return reduce(lambda x, y: x * y, filter(pred, lista_digitos(n)))
