def resumo_fp(notas):
    notasp, alunosp, alunosn = 0, 0, 0
    for nota in notas:
        count = len(notas[nota])
        if nota >= 10:
            notasp += nota * count
            alunosp += count
        else:
            alunosn += count
    return notasp / alunosp, alunosn


print(resumo_fp({1: [46592, 49212, 90300, 59312], 15: [52592, 59212], 20: [58323]}))
