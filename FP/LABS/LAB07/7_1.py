def cria_rac(n, d):
    if type(n) != int or type(d) != int or d < 0:
        raise ValueError("Invalido")
    return {"num": n, "den": d}


def num(r):
    return r["num"]


def den(r):
    return r["den"]


def eh_racional(arg):
    return type(arg['num']) == int and type(arg['den']) == int and arg['den'] > 0


def eh_racional_zero(r):
    return eh_racional(r) and num(r) == 0


def rac_iguais(r1, r2):
    return num(r1) * den(r2) == den(r1) * num(r2)


def escreve_rac(r):
    return "{}/{}".format(num(r), den(r))


def produto_rac(r1, r2):
    return cria_rac(num(r1)*num(r2), den(r1)*den(r2))


print(escreve_rac(produto_rac(cria_rac(1, 3), cria_rac(3, 4))))
