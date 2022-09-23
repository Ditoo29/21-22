def eh_primo(n):
    if n == 1:
        return False
    else:
        for i in range(2, n):
            if n % i == 0:
                return False
    return True


def nao_primos(n):
    if n == 0:
        return []
    if not eh_primo(n):
        return nao_primos(n - 1) + [n]
    else:
        return nao_primos(n - 1)


print(nao_primos(10))
