i = 1
n = 0
while i < 10:
    n *= 10
    n += i
    print(n,"x 8", i, "=", n*8 + i)
    i += 1