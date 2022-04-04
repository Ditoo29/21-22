x = eval(input("Introduz o 1º número: "))
y = eval(input("Introduz o 2º número: "))
z = eval(input("Introduz o 3º número: "))

if (x > y) and (x > z):
    print("O primeiro é maior")
elif (y > x) and (y > z):
    print("O segundo é maior")
else:
    print("O terceiro é maior")