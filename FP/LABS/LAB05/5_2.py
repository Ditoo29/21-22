def remove_multiplos(lista, n):
    lista2 = []
    for i in lista:
        if i % n != 0:
            lista2.append(i)
    return lista2


print(remove_multiplos([2, 3, 5, 9, 12, 33, 34, 45], 3))
