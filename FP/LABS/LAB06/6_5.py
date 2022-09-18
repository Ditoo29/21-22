def metabolismo(d):
    nd = {}

    def m(s, i, h, p):
        if s == "M":
            return 66 + 6.3 * p + 12.9 * h + 6.8 * i
        elif s == "F":
            return 655 + (4.3 * p) + (4.7 * h) + (4.7 * i)

    for keys in d:
        nd[keys] = m(d[keys][0], d[keys][1], d[keys][2], d[keys][3])
    return nd


print(metabolismo({"Maria": ("F", 34, 1.65, 64), "Pedro": ("M", 34, 1.65, 64),
                   "Ana": ("F", 54, 1.65, 120), "Hugo": ("M", 12, 1.82, 75)}))
