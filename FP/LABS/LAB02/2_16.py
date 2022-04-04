n = int(input("Escreve um número: "))
f = n
d = 0
while True:
    d += n % 10
    n //= 10
    if n == 0:
        break
    d *= 10
print(f"{f}{d}")