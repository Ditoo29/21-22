n = int(input("Escreve um número: "))
r = 0
while n != 0:
    d = n % 10
    n //= 10
    r += d
print(r)
