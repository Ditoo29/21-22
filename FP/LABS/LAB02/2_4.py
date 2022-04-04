s = int(input("Escreve um número inteiro de segundos: "))

d = s//(60*60*24)
s -= (d*60*60*24)

h = s//(60*60)
s -= (h*60*60)

m = s//60
s -= (m*60)

print ("Dias:", d, " Horas:", h, " Minutos:", m, " Segundos:", s)