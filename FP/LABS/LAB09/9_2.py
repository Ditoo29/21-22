def junta_ordenadas(l1, l2):
    if len(l1) == 0 or len(l2) == 0:
        return l1 + l2
    elif l1[0] < l2[0]:
        return [l1[0]] + junta_ordenadas(l1[1:], l2)
    else:
        return [l2[0]] + junta_ordenadas(l1, l2[1:])


print(junta_ordenadas([2, 5, 90], [3, 5, 6, 12]))
