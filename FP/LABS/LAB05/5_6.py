def soma_matriz(m1, m2):
    result = m1 + []
    for l in range(len(m1)):
        rs = m1[l] + []
        for c in range(len(m1[l])):
            rs[c] = m1[l][c] + m2[l][c]
        result[l] = rs
    print(result)


m1 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
m2 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

soma_matriz(m1, m2)
