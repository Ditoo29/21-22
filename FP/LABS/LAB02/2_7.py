ht = eval(input("Horas trabalhadas: "))
sh = eval(input("Salário/Hora: "))

if 0<=ht<=40:
    sal = ht*sh
    print("O seu ordenado é: ", sal)
elif ht>40:
    sal = (40*sh) + (ht-40)*(2*sh)
    print("O seu ordenado é: ", sal)
else:
    print("Número de horas inválido")