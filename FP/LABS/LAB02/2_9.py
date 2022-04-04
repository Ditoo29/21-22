n = ''

while True:
    print('Escreva um dígito\n(-1 para terminar)')
    d = input('? ')
    if d == '-1':
        print('O número é', n)
        break
    n += d

# codigo funciona pq "n" e "d" foram definidos como strings, e não valores artimeticos
