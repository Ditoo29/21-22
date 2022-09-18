def conta_vogais(fname):
    fh = open(fname, "r")
    d = {"a": 0, "e": 0, "i": 0, "o": 0, "u": 0}
    for linha in fh.readlines():
        for c in linha:
            if c in d:
                d[c] += 1
    fh.close()
    return d


print(conta_vogais("ex.txt"))
