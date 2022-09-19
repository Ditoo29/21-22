def parte(l, n):
    def parte_aux(greater, less, l, n):
        if len(l) == 0:
            return [less, greater]
        if l[0] < n:
            return parte_aux(greater, less + [l[0]], l[1:], n)
        return parte_aux(greater + [l[0]], less, l[1:], n)

    return parte_aux([], [], l, n)