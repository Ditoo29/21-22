def espelho(n):
    def espelho_aux(n, t):
        if n == 0:
            return t
        else:
            return espelho_aux(n // 10, t * 10 + n % 10)
    return espelho_aux(n, 0)

