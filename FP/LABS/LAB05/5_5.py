def matriz(m):
    rs = ""
    for l in m:
        for i in l:
            rs += str(i) + " "
        rs += "\n"
    print(rs)


matriz([[1, 2, 3], [4, 5, 6]])
