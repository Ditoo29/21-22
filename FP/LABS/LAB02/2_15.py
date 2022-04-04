r = 0
while True:
    n = int(input("Escreve um número: "))
    if n == -1:
        break
    r = r * 10 + n
print (r)