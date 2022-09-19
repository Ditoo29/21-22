def numero_digitos(n):
    if n == 0:
        return 0
    else:
        return 1 + numero_digitos(n // 10)


def numero_digitosb(n):
    def numero_digitos_aux(n, t):
        if n == 0:
            return t
        else:
            return numero_digitos_aux(n // 10, t + 1)

    return numero_digitos_aux(n, 0)

def numero_digitosc(n):
    t = 0
    while n > 0:
        n //= 10
        t += 1
    return t