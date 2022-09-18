def corta(entrada, saida, n):
    fe = open(entrada, "r")
    fs = open(saida, "w")
    for p in fe.read(n):
        fs.write(p)
    fe.close()
    fs.close()


print(corta("entrada.txt", "saida.txt", 20))
