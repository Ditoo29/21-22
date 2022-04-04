def dia_semana(d, m, a):

    if m < 3:
        m += 12
    h = ((d + (13 * (m + 1)) // 5 + (a % 100) + (a % 100) // 4 + (a//100) // 4 - 2*(a//100)) % 7)
    print(d,m,a,h)
    if h == 0:
        return("sabado")
    if h == 1:
        return("domingo")
    if h == 2:
        return("segunda")
    if h == 3:
        return("terça")
    if h == 4:
        return("quarta")
    if h == 5:
        return("quinta")
    if h == 6:
        return("sexta")
print (dia_semana(eval(input("Escrever o dia: ")), (eval(input("Escrever o mes: "))), (eval(input("Escrever o ano: ")))))