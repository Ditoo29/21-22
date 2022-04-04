n = int(input("Escreve um número inteiro: "))
c = 0
while n != 0:
    d = n % 10
    if d == 0 and n % 10 == 0:
        c += 1
    n //= 10
print(c, "zeros seguidos.")
