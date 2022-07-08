def racaman(n):
    l = []
    for i in range(n):
        if i == 0:
            l.append(i)
        elif l[i - 1] > i and (l[i - 1] - i) not in l:
            l += [l[i - 1] - i]
        else:
            l += [l[i - 1] + i]
    return l


print(racaman(15))
