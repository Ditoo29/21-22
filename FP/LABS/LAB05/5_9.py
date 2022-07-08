def numero_occ_lista(l, n):
    s = 0
    for i in l:
        if i == n:
            s += 1
    return s


print(numero_occ_lista([1, 2, 3, 4, 3], 3))
