def sublistas(l):
    if len(l) == 0:
        return 0
    elif type(l[0]) == list:
        return 1 + sublistas(l[0]) + sublistas(l[1:])
    else:
        return sublistas(l[1:])


print(sublistas(["a", [2, 3, [[[1]], 6, 7], "b"]]))