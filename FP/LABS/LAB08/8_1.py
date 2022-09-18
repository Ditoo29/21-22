def conta_linhas(fname):
    fh = open(fname, "r")
    count = 0
    for linha in fh.readlines():
        if len(linha) > 1:
            count += 1
    fh.close()
    return count


print(conta_linhas("rename.txt"))
