def implode(n):
    s = 0
    if type(n) != tuple:
        raise ValueError("Número não inteiro")
    for i in n:
        s = s * 10 + i
    return s


print(implode((2, 4, 5)))
