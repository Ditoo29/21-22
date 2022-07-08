def filtra_pares(n):
    s = ()
    for i in n:
        if i % 2 == 0:
            s += (i,)
    return s
print(filtra_pares((2,3,4)))