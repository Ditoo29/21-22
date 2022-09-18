def concatena(lst, saida):
    fhs = open(saida, "w")
    for f in lst:
        fh = open(f, "r")
        fhs.write(fh.read())
        fh.close()
    fhs.close()