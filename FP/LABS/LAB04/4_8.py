def junta_ordenados(t1, t2):
    i1 = 0
    i2 = 0
    res = ()
    while i1 < len(t1) and i2 < len(t2):
        if t1[i1] < t2[i2]:
            res += (t1[i1],)
            i1 += 1
        else:
            res += (t2[i2],)
            i2 += 1
    if i1 == len(t1):
        res += (t2[i2:])
    else:
        res += (t1[i1:])
    return res


print(junta_ordenados((2, 34, 200, 210), (1, 23)))
