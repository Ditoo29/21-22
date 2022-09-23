def piatorio(l_i, l_s, trans, incre):
    res = 1
    while l_i <= l_s:
        res *= trans(l_i)
        l_i = incre(l_i)
    return res


def fatorial(n):
    return piatorio(1, n, lambda x: x, lambda x: x + 1)


print(fatorial(5))