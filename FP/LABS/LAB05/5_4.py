def elemento_matriz(m, l, c):
    if l > len(m):
        raise ValueError("Índice inválido")
    if c > len(m):
        raise ValueError("Índice inválido")
    return m[l][c]


m = [[1, 2, 3], [4, 5, 6]]
print(elemento_matriz(m, 0, 0))
