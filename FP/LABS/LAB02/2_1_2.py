def cria_animal(s, r, a):
    if type(s) != str or len(s) < 1 or type(r) != int or r < 1 or type(a) != int or a < 0:
        return ValueError("argumentos invalidos")
    i = 0
    f = 0
    return [s, r, a, i, f]


def cria_copia_animal(a):
    na = [a[0], a[1], a[2], a[3], a[4]]
    return na


def obter_especie(a):
    return a[0]


def obter_freq_reproducao(a):
    return a[1]


def obter_freq_alimentacao(a):
    return a[2]


def obter_idade(a):
    return a[3]


def obter_fome(a):
    return a[4]


def aumenta_idade(a):
    a[3] += 1
    return a


def reset_idade(a):
    a[3] = 0
    return a


def aumenta_fome(a):
    if a[2] > 0:
        a[4] += 1
    return a


def reset_fome(a):
    if a[2] > 0:
        a[4] = 0
    return a


def eh_animal(arg):
    if type(arg) != list or len(arg) != 5 or type(arg[0]) != str or len(arg[0]) < 1 or type(arg[1]) != int or \
            arg[1] < 1 or type(arg[2]) != int or arg[2] < 0 or type(arg[3]) != int or arg[3] < 0 or \
            type(arg[4]) != int or arg[4] < 0:
        return False
    return True


def eh_predador(arg):
    if not eh_animal(arg):
        return False
    elif arg[2] == 0:
        return False
    return True


def eh_presa(arg):
    if not eh_animal(arg):
        return False
    elif arg[2] != 0:
        return False
    return True


def animais_iguais(a1, a2):
    if not eh_animal(a1) or not eh_animal(a2):
        return False
    elif a1 != a2:
        return False
    return True


def animal_para_char(a):
    if eh_predador(a):
        s = a[0][0]
        return s.upper()
    return a[0][0]


def animal_para_str(a):
    if eh_predador(a):
        return f"{a[0]} [{a[3]}/{a[1]};{a[4]}/{a[2]}]"
    return f"{a[0]} [{a[3]}/{a[1]}]"


def eh_animal_fertil(a):
    if not eh_animal(a):
        return False
    elif obter_idade(a) == obter_freq_reproducao(a):
        return True
    return False


def eh_animal_faminto(a):
    if not eh_animal(a):
        return False
    elif obter_fome(a) >= obter_freq_alimentacao(a):
        return True
    return False


def reproduz_animal(a):
    a = reset_idade(a)
    return cria_animal(obter_especie(a), obter_freq_reproducao(a), obter_freq_alimentacao(a))


f1 = cria_animal("fox", 20, 10)
r1 = cria_animal("rabbit", 5, 0)

f2 = cria_copia_animal(f1)
f2 = aumenta_idade(aumenta_idade(f2))
f2 = aumenta_fome(f2)

print(f2)

f3 = reproduz_animal(f2)
print(animal_para_str(f2))
print(animal_para_str(f3))
