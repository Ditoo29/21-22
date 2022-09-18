def inverte(f1, f2):
    f1 = open(f1, "r")
    linhas = f1.readlines()
    f1.close()
    f2 = open(f2, "w")
    for i in linhas[::-1]:
        f2.write(i)
    f2.close()
    return "ola"


print(inverte("ex.txt", "ex2.txt"))
