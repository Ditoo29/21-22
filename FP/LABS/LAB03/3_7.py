def valor(q, j, n):
    if j > 1 or j < 0:
        raise ValueError("J deverá estar entre 0 e 1.")
    return q * (1 + j) ** n


def duplicar(q, j):
    if j > 1 or j < 0:
        raise ValueError("J deverá estar entre 0 e 1.")
    c = 0
    while True:
        c += 1
        if valor(q, j, c) >= 2 * q:
            return c


print(duplicar(eval(input("Escreve q: ")), eval(input("Escreve j: "))))
