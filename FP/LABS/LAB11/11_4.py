from functools import reduce


def filtra(lst, tst):
    return list(filter(tst, lst))


def filtra_r(lst, tst):
    if len(lst) == 0:
        return []
    elif tst(lst[0]):
        return [lst[0]] + filtra_r(lst[1:], tst)
    else:
        return filtra_r(lst[1:], tst)


def transforma(lst, tst):
    return list(map(tst, lst))


def transforma_r(lst, tst):
    if len(lst) == 0:
        return []
    return [tst(lst[0])] + transforma_r(lst[1:], tst)


def acumulador(lst, tst):
    return reduce(tst, lst)


def acumulador_r(lst, tst):
    if len(lst) == 0:
        return 0
    return tst(0, lst[0]) + acumulador_r(lst[1:], tst)


print(acumulador_r([1, 2, 3, 4], lambda x, y: x + y))
