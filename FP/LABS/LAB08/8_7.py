def ordena_ficheiro(f):
    fh = open(f, "r")
    linhas = sorted(fh.readlines())
    fs = open(f, "w")
    fs.writelines(linhas)
