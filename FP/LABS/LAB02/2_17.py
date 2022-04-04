p = 0
t = 0
while True:
    n = int(input("Escreve a nota do teste (-1 para terminar): "))
    if n == -1:
        break
    t += 1
    if n >= 10:
        p += 1
print("Número de positivas:", p)
print("Percentagem de positivas:", p / t * 100, "%")
