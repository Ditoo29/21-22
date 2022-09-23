def soma_fn(n, fn):
    res = 0
    l_i = 1
    for i in range(n):
        res += fn(l_i)
        l_i += 1
    return res


def soma_fn_r(n, fn):
    if n == 0:
        return 0
    return fn(n) + soma_fn_r(n - 1, fn)


print(soma_fn_r(4, lambda x: x + 1))
