def bissexto(ano):
    return ((ano % 4 == 0 and ano % 100 != 0) or (ano % 400 == 0))

def dias_mes (mes, ano):
    if mes == "jan" or mes == "mar" or mes == "mai" or mes == "jul" or mes == "ago" or mes == "out" or mes == "dez":
        return(31)
    elif mes == "abr" or mes == "jun" or mes == "set" or mes == "nov":
        return (30)
    elif mes == "fev":
        if ano < 0:
            raise ValueError("Ano não existe")
        if bissexto(ano):
            return(29)
        else:
            return(28)
    else:
        raise ValueError("Mês não existe")