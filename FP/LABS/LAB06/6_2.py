def agrupa_por_chave(lst):
    d = {}
    for key, value in lst:
        if key in d.keys():
            d[key] += [value]
        else:
            d[key] = [value]
    return d


print(agrupa_por_chave([("a", 8), ("b", 9), ("a", 3)]))
