km = eval(input("Escreve a distância em Km: "))
min = eval(input("Escreve o tempo necessário para concluir: "))

kmh = km/(min/60)
ms = (km*1000)/(min*60)

print("Velocidade em Km/H: ",kmh )
print("Velocidade em m/s: ",ms )

