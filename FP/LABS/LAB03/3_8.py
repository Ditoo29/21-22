def serie_geo(r, n):
    c = 0
    i = 0
    if n < 0:
        raise ValueError("n não pode ser negativo")
    while i <= n:
        c += r ** i
        i += 1
    return c


print(serie_geo(int(input("Escreve r: ")), (int(input("Escreve n: ")))))
