def palavras(frase):
    d = {}
    for i in frase.split(" "):
        if i in d:
            d[i] += 1
        else:
            d[i] = 1
    return d


print(palavras("a aranha arranha a ra a ra arranha a aranha " + "nem a aranha arranha a ra nem a ra arranha a aranha"))
