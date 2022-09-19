def apenas_digitos_impares(n):
    if n == 0:
        return 0
    d = n % 10
    if d % 2 == 0:
        return apenas_digitos_impares(n // 10)
    else:
        return apenas_digitos_impares(n // 10) * 10 + d

print(apenas_digitos_impares(12426374856))
