def amigas(p1, p2):
    if len(p1) != len(p2):
        raise ValueError("Palavras com tamanhos diferentes")
    t = 0
    for i in range(len(p1)):
        if p1[i] == p2[i]:
            t += 1
    return t / len(p1) > 0.9


print(amigas("amigas", "asigos"))
