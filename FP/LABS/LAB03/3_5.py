def bissexto(ano):
    return ((ano % 4 == 0 and ano % 100 != 0) or (ano % 400 == 0))


print(bissexto(int(input("Escreve um ano: "))))