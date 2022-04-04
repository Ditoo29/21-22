def area_circulo(raio):
    return 3.14 * (raio ** 2)


def area_coroa(r1, r2):
    if r1 > r2:
        raise ValueError("O valor do raio 1 é maior do que o valor do raio 2")
    return area_circulo(r2) - area_circulo(r1)


print(area_coroa(eval(input("Escreve o r1: ")), eval(input("Escreve o r2: "))))
