def explode(n):
    if type(n) != int:
        raise ValueError("Argumento não inteiro")
    if n <= 0:
        raise ValueError("Argumento não positivo")
    t = ()
    while n > 0:
        t = (n % 10,) + t
        n //= 10
    return t


print(explode(34500))
