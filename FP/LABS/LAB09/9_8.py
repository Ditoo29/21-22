def pertence(l, n):
    if len(l) == 0:
        return False
    if l[0] == n:
        return True
    return pertence(l[1:], n)


def subtrai(l1, l2):
    if len(l1) == 0:
        return []
    if pertence(l2, l1[0]):
        return subtrai(l1[1:], l2)
    else:
        return [l1[0]] + subtrai(l1[1:], l2)


print(subtrai([2, 3, 4, 5], [2, 3]))
