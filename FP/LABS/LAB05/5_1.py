def lista_codigos(n):
    total = []
    for i in n:
        total.append(ord(i))
    return total


print(lista_codigos("bom dia"))
