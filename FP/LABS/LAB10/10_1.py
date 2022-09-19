def quadrado(n):
    if n <= 1:
        return 1
    else:
        return (n + n - 1) + quadrado(n-1)

def squared(n):
    def squared_aux(n, acc):
        if n <= 1:
            return acc + 1
        return squared_aux(n-1, acc + n + n-1)
    return squared_aux(n, 0)

def quadradoc(n):
    t = 0
    for i in range(n, n + 1):
        t += i + i - 1
    return t
