def num_para_seq_cod(n):
    t = ()
    while n > 0:
        d = n % 10
        n //= 10
        if d % 2 == 0:
            t = ((d + 2) % 10,) + t
        elif d == 1:
            t = (9,) + t
        else:
            t = ((d - 2) % 10,) + t
    return t


print(num_para_seq_cod(1234567890))
