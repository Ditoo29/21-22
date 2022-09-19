def soma_n_vezes(a, b, n):
    if n == 0:
        return 0
    else:
        return b + a + soma_n_vezes(a, 0, n - 1)


print(soma_n_vezes(3, 2, 5))
