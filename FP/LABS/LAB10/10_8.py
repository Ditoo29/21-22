def maior_inteiro(n):
    t = 0
    c = 0
    for i in range(1, n - 1):
        if t + i < n:
            t += i
            c += 1
    return c


print(maior_inteiro(20))
