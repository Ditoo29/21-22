def pertence(l, n):
    if len(l) == 0:
        return False
    if l[0] == n:
        return True
    return pertence(l[1:], n)


print(pertence([3, 4, 5], 5))
