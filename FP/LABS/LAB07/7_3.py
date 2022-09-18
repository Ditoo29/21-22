def eh_bissexto(a):
    return (a % 4 == 0 and a % 100 != 0) or a % 400 == 0


def obter_dias_mes(m, bissexto):
    return {1: 31, 2: 29 if bissexto else 28, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31}[
        m]


def cria_data(d, m, a):
    if type(d) != int or type(m) != int or type(a) != int:
        raise ValueError("Invalido")
    return {"dia": d, "mes": m, "ano": a}


def dia(dt):
    return dt["dia"]


def mes(dt):
    return dt["mes"]


def ano(dt):
    return dt["ano"]


def eh_data(arg):
    if type(arg) != dict or 'dia' not in arg or 'mes' not in arg or 'ano' not in arg:
        return False
    d, m, a = arg["dia"], arg["mes"], arg["ano"]
    return type(dia) == int and type(mes) == int and type(ano) == int and 1 <= m <= 12 and 1 <= d <= \
           obter_dias_mes(m, eh_bissexto(a))


def mesma_data(d1, d2):
    return d1["dia"] == d2["dia"] and d1["mes"] == d2["mes"] and d1["ano"] == d2["ano"]


def escreve_data(data):
    if data["ano"] < 0:
        return data["dia"], "/", data["mes"], "/", -data["ano"], "AC"
    else:
        return data["dia"], "/", data["mes"], "/", data["ano"]


print(escreve_data(cria_data(28, 8, 20)))


def data_anterior(d1, d2):
    return d1["ano"] < d2["ano"] or d1["ano"] == d2["ano"] and d1["mes"] < d2["mes"] or d1["mes"] == d2["mes"] and d1[
        "dia"] < d2["dia"]


print(data_anterior(cria_data(26, 7, 2000), cria_data(27, 7, 2000)))
