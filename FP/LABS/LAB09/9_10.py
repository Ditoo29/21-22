def maior(l):
    def maior_aux(l, n):
        if len(l) == 0:
            return n
        if l[0] > n:
            return maior_aux(l[1:], l[0])
        else:
            return maior_aux(l[1:], n)
    return maior_aux(l, l[0])
