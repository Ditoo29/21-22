def divide(f, n):
    fe = open(f, "r")
    f0 = open(f + "0", "w")
    f1 = open(f + "1", "w")
    for linha in fe.readlines():
        f0.write(linha[:n] + "\n")
        f1.write(linha[n:])
    fe.close()
    f0.close()
    f1.close()


print(divide("entrada.txt", 20))
