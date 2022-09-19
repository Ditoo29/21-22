def inverte(l):
    if len(l) == 0:
        return []
    else:
        return inverte(l[1:]) + [l[0]]

print(inverte([3, 4, 7, 9]))