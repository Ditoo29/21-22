def procura(palavra, f):
    fh = open(f, "r")
    for linha in fh.readlines():
        if palavra in linha:
            print(linha)
    fh.close()
