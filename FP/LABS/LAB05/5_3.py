def soma_cumulativa(lista):
    s = 0
    lista2 = []
    for i in lista:
        s += i
        lista2.append(s)
    return lista2


print(soma_cumulativa([1, 2, 3, 4, 5]))
