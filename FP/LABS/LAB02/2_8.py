x = 0

while True:
    x = int(input("Escreve um numero inteiro (segundos) ou negativo para terminar: "))
    if x<0:
        break
    dias = x / (60 * 60 * 24)
    print("Corresponde a", dias, "dias.")

