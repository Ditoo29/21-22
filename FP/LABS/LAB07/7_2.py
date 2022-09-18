def cria_rel(h, m, s):
    if type(h) != int or type(m) != int or type(s) != int or 0 > h > 23 or 0 > m > 59 or 0 > s > 59:
        raise ValueError("Invalido")
    return [h, m, s]


def horas(r):
    return r[0]


def minutos(r):
    return r[1]


def segundos(r):
    return r[2]


def eh_relogio(arg):
    return type(arg) == list and len(arg) == 3 and type(arg[0]) == int and type(arg[1]) == int and type(arg[2]) == int \
           and 0 <= arg[0] < 24 and 0 <= arg[1] < 60 and 0 <= arg[2] < 60


def eh_meia_noite(r):
    return eh_relogio(r) and horas(r) == minutos(r) == segundos(r) == 0


def eh_meio_dia(r):
    return eh_relogio(r) and horas(r) == 12 and minutos(r) == segundos(r) == 0


def mesmas_horas(r1, r2):
    if not all(eh_relogio(r1) or eh_relogio(r2)):
        raise ValueError("Invalido")
    return horas(r1) == horas(r2) and minutos(r1) == minutos(r2) and segundos(r1) == segundos(r2)


def escreve_relogio(r):
    return "{}:{}:{}".format(horas(r), minutos(r), segundos(r))


def depois_rel(r1, r2):
    if not eh_relogio(r1) or not eh_relogio(r2):
        raise ValueError("Invalido")
    return horas(r1) < horas(r2) or horas(r1) == horas(r2) and minutos(r1) < minutos(r2) or horas(r1) == horas(r2) \
           and minutos(r1) == minutos(r2) and segundos(r1) < segundos(r2)


print(depois_rel([10, 6, 45], [10, 6, 47]))
