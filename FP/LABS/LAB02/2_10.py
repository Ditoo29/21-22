n = int(input("Escreve um número: "))
r = 0
i = 0
while n != 0:
    d = n % 10
    n //= 10
    if d % 2 == 1:
        r += d * (10**i)
        i += 1
print (r)