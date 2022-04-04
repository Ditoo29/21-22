# 2.1.1

def cria_posicao(x, y):
    """ int × int → posicao
    Recebe os valores correspondentes às coordenadas de uma posição e devolve a posição correspondente.
    O construtor verifica a validade dos seus argumentos."""

    if type(x) != int or type(y) != int or x < 0 or y < 0:
        raise ValueError("cria_posicao: argumentos invalidos")
    return (x, y)


def cria_copia_posicao(p):
    """posicao → posicao
    Criar a cópia da posição (objeto diferente)"""

    np = (p[0], p[1])
    return np


def obter_pos_x(p):
    """posicao → int
    Obter a posição X da posição"""

    return p[0]


def obter_pos_y(p):
    """posicao → int
    Obter a posição Y da posição"""

    return p[1]


def eh_posicao(arg):
    """universal → booleano
    Verificar se o argumento dado é uma posição"""

    if type(arg) != tuple or len(arg) != 2 or type(arg[0]) != int or type(arg[1]) != int or arg[0] < 0 or arg[1] < 0:
        return False
    return True


def posicoes_iguais(pos1, pos2):
    """posicao × posicao → booleano
    Verifica se a posição 1 e 2 são iguais"""

    if pos1 != pos2:
        return False
    return True


def posicao_para_str(p):
    """posicao → str
    Transforma uma posição dada na string correspondente"""

    return f"({p[0]}, {p[1]})"


def obter_posicoes_adjacentes(p):
    """posicao → tuplo
    Devolve um tuplo com as posições adjacentes à posição "p", começando pela posição acima de p e seguindo
    no sentido horário."""

    result = ()  # utilizado para dar store às posições
    x, y = obter_pos_x(p), obter_pos_y(p)
    if y - 1 >= 0:
        result += (cria_posicao(x, y - 1),)
    result += (cria_posicao(x + 1, y),)
    result += (cria_posicao(x, y + 1),)
    if x - 1 >= 0:
        result += (cria_posicao(x - 1, y),)
    return result


def ordenar_posicoes(tup):
    """tuplo → tuplo
    Devolve um tuplo contendo as mesmas posições do tuplo fornecido como argumento, ordenadas de acordo
    com a ordem de leitura do prado."""

    return tuple(sorted(tup, key=lambda tu: (obter_pos_y(tu), obter_pos_x(tu))))


# 2.1.2

def cria_animal(s, r, a):
    """str × int × int → animal
    Recebe uma cadeia de caracteres "s" não vazia correspondente à espécie do animal e dois valores inteiros
    correspondentes à frequência de reprodução "r" (maior do que 0) e à frequência de alimentação "a"
    (maior ou igual que 0); e devolve o animal. Animais com frequência de alimentação maior que 0 são considerados
    predadores, caso contrário são considerados presas. O construtor verifica a validade dos seus argumentos,"""

    if type(s) != str or len(s) < 1 or type(r) != int or r < 1 or type(a) != int or a < 0:
        raise ValueError("cria_animal: argumentos invalidos")
    i = 0
    f = 0
    return [s, r, a, i, f]


def cria_copia_animal(a):
    """ animal → animal
    Recebe um animal a (predador ou presa) e devolve uma
    nova cópia do animal."""

    na = [a[0], a[1], a[2], a[3], a[4]]
    return na


def obter_especie(a):
    """animal → str
    Devolve a cadeia de caracteres correspondente à espécie do
    animal."""

    return a[0]


def obter_freq_reproducao(a):
    """animal → int
    Devolve a frequência de reprodução do animal "a"."""

    return a[1]


def obter_freq_alimentacao(a):
    """animal → int
    Devolve a frequência de alimentação do animal "a" (as presas devolvem sempre 0)"""

    return a[2]


def obter_idade(a):
    """animal → int
    Devolve a idade do animal "a"."""

    return a[3]


def obter_fome(a):
    """animal → int
    Devolve a fome do animal "a" (as presas devolvem sempre 0)."""

    return a[4]


def aumenta_idade(a):
    """animal → animal
    Modifica destrutivamente o animal "a" incrementando o valor da sua idade em uma unidade,
    e devolve o próprio animal."""

    a[3] += 1
    return a


def reset_idade(a):
    """animal → animal
    Modifica destrutivamente o animal a definindo o valor da sua idade igual a 0, e devolve o próprio animal."""

    a[3] = 0
    return a


def aumenta_fome(a):
    """animal → animal
    Modifica destrutivamente o animal predador "a" incrementando o valor da sua fome em uma unidade,
    e devolve o próprio animal. Esta operação não modifica os animais presa."""

    if a[2] > 0:
        a[4] += 1
    return a


def reset_fome(a):
    """animal → animal
    Modifica destrutivamente o animal predador "a" definindo o valor da sua fome igual a 0, e devolve o próprio animal.
    Esta operação não modifica os animais presa."""

    if a[2] > 0:
        a[4] = 0
    return a


def eh_animal(arg):
    """universal → booleano
    Devolve True caso o seu argumento seja um TAD animal e False caso contrário."""

    if type(arg) != list or len(arg) != 5 or type(arg[0]) != str or len(arg[0]) < 1 or type(arg[1]) != int or \
            arg[1] < 1 or type(arg[2]) != int or arg[2] < 0 or type(arg[3]) != int or arg[3] < 0 or \
            type(arg[4]) != int or arg[4] < 0:
        return False
    return True


def eh_predador(arg):
    """universal → booleano
    Devolve True caso o seu argumento seja um TAD animal do tipo predador e False caso contrário."""

    if not eh_animal(arg):
        return False
    elif arg[2] == 0:
        return False
    return True


def eh_presa(arg):
    """universal → booleano
    Devolve True caso o seu argumento seja um TAD animal do tipo presa e False caso contrário."""

    if not eh_animal(arg):
        return False
    elif arg[2] != 0:
        return False
    return True


def animais_iguais(a1, a2):
    """animal × animal → booleano
    Devolve True apenas se a1 e a2 são animais e são iguais."""

    if not eh_animal(a1) or not eh_animal(a2):
        return False
    elif a1 != a2:
        return False
    return True


def animal_para_char(a):
    """animal → str
    Devolve a cadeia de caracteres dum único elemento correspondente ao primeiro carácter da espácie do animal
    passada pelo argumento, em maiúscula para animais predadores e em minúscula para animais presa."""

    if eh_predador(a):
        s = a[0][0]
        return s.upper()  # verificação da letra maiúscula
    else:
        s = a[0][0]
        return s.lower()  # verificação da letra minúscula


def animal_para_str(a):
    """animal → str
    Devolve a cadeia de caracteres que representa o animal
    como mostrado nos exemplos a seguir."""

    if eh_predador(a):
        return f"{a[0]} [{a[3]}/{a[1]};{a[4]}/{a[2]}]"
    return f"{a[0]} [{a[3]}/{a[1]}]"


def eh_animal_fertil(a):
    """animal → booleano
    Devolve True caso o animal "a" tenha atingido a idade de reprodução e False caso contrário."""

    if not eh_animal(a):
        return False
    elif obter_idade(a) >= obter_freq_reproducao(a):
        return True
    return False


def eh_animal_faminto(a):
    """animal → booleano
    Devolve True caso o animal a tenha atingindo um valor de
    fome igual ou superior à sua frequência de alimentação e False caso contrário. As presas devolvem sempre False."""

    if not eh_animal(a):
        return False
    elif eh_presa(a):
        return False
    elif obter_fome(a) >= obter_freq_alimentacao(a):
        return True
    return False


def reproduz_animal(a):
    """animal → animal
    Recebe um animal "a" devolvendo um novo animal da mesma
    espécie com idade e fome igual a 0, modificando destrutivamente o animal passado
    como argumento "a" alterando a sua idade para 0."""

    a = reset_idade(a)
    return cria_animal(obter_especie(a), obter_freq_reproducao(a), obter_freq_alimentacao(a))


# 2.1.3

def cria_prado(d, r, a, p):
    """posicao × tuplo × tuplo × tuplo → prado
    Recebe uma posição "d" correspondente à posição que ocupa a montanha do canto inferior direito do prado,
    um tuplo "r" de 0 ou mais posições correspondentes aos rochedos que não são as montanhas dos
    limites exteriores do prado, um tuplo "a" de 1 ou mais animais, e um tuplo "p" da
    mesma dimensão do tuplo "a" com as posições correspondentes ocupadas pelos
    animais. Devolve o prado que representa internamente o mapa e os animais
    presentes. O construtor verifica a validade dos seus argumentos, gerando um ValueError."""

    if not eh_posicao(d) or type(r) != tuple or type(a) != tuple or len(a) < 1 or type(p) != tuple or len(p) != len(a):
        raise ValueError("cria_prado: argumentos invalidos")
    for e in r:
        if not eh_posicao(e) or obter_pos_x(e) < 1 or obter_pos_x(e) > obter_pos_x(d) - 1 or obter_pos_y(e) < 1 or \
                obter_pos_y(e) > obter_pos_y(d) - 1:
            raise ValueError("cria_prado: argumentos invalidos")
    for e in a:
        if not eh_animal(e):
            raise ValueError("cria_prado: argumentos invalidos")
    for e in p:
        if not eh_posicao(e) or obter_pos_x(e) < 1 or obter_pos_x(e) > obter_pos_x(d) - 1 or obter_pos_y(e) < 1 or \
                obter_pos_y(e) > obter_pos_y(d) - 1:
            raise ValueError("cria_prado: argumentos invalidos")
    return [d, r, a, p]


def cria_copia_prado(m):
    """prado → prado
    Recebe um prado e devolve uma nova cópia do prado."""

    np = [m[0], m[1], m[2], m[3]]
    return np


def obter_tamanho_x(m):
    """prado → int
    Devolve o valor inteiro que corresponde à dimensão Nx do prado."""

    return obter_pos_x(m[0]) + 1


def obter_tamanho_y(m):
    """prado → int
    Devolve o valor inteiro que corresponde à dimensão Ny do prado."""

    return obter_pos_y(m[0]) + 1


def obter_numero_predadores(m):
    """prado → int
    Devolve o número de animais predadores no prado."""

    c = 0
    for e in obter_posicao_animais(m):
        if eh_predador(obter_animal(m, e)):
            c += 1
    return c


def obter_numero_presas(m):
    """prado → int
    Devolve o número de animais presa no prado."""

    c = 0
    for e in obter_posicao_animais(m):
        if eh_presa(obter_animal(m, e)):
            c += 1
    return c


def obter_posicao_animais(m):
    """prado → tuplo posicoes
    Devolve um tuplo contendo as posições do prado ocupadas por animais, ordenadas em ordem de leitura do prado."""

    return ordenar_posicoes(m[3])


def obter_animal(m, p):
    """prado × posicao → animal
    Devolve o animal do prado que se encontra na posição p."""

    for e in range(len(m[3])):
        if posicoes_iguais(m[3][e], p):
            # Compara as posições dos animais com a posição dada, devolvendo o animal correspondente
            return m[2][e]


def eliminar_animal(m, p):
    """prado × posicao → prado
    Modifica destrutivamente o prado m eliminando o animal da posição "p" deixando-a livre. Devolve o próprio prado."""

    # necessário alterar os tuplos para listas de modo a alterá-los
    m2 = list(m[2])
    m3 = list(m[3])
    for e in range(len(m3)):
        if posicoes_iguais(m3[e], p):
            del m3[e]
            del m2[e]
            break
    # necessário alterar as listas para tuplos novamente
    m[2] = tuple(m2)
    m[3] = tuple(m3)
    return m


def mover_animal(m, p1, p2):
    """prado × posicao × posicao → prado
    Modifica destrutivamente o prado "m" movimentando o animal da posição "p1" para a nova posição "p2",
    deixando livre a posição onde se encontrava. Devolve o próprio prado."""

    m3 = list(m[3])
    for e in range(len(m3)):
        if posicoes_iguais(m3[e], p1):
            if eh_posicao_livre(m, p2):  # Mover apenas se a nova posição estiver livre
                m3[e] = p2
    m[3] = tuple(m3)
    return m


def inserir_animal(m, a, p):
    """prado × animal × posicao → prado
    Modifica destrutivamente o prado "m" acrescentando na posição "p" do prado o animal "a" passado com argumento.
    Devolve o próprio prado."""

    m2 = list(m[2])
    m3 = list(m[3])
    if eh_posicao_livre(m, p):
        m3.append(p)  # inserir a nova posição na lista se a mesma estiver livre
        m[3] = tuple(m3)
        for e in range(len(m[3])):
            if posicoes_iguais(m3[e], p):
                m2.insert(e, a)
        m[2] = tuple(m2)  # inserir o animal no sitio correto
    return m


def eh_prado(arg):
    """universal → booleano
    Devolve True caso o seu argumento seja um TAD prado e False caso contrário."""

    if type(arg) != list or len(arg) != 4 or not eh_posicao(arg[0]) or type(arg[1]) != tuple or type(arg[2]) != tuple \
            or len(arg[2]) < 1 or type(arg[3]) != tuple or len(arg[3]) != len(arg[2]):
        return False
    return True


def eh_posicao_animal(m, p):
    """prado × posicao → booleano
    Devolve True apenas no caso da posição "p" do prado estar ocupada por um animal."""

    for e in m[3]:
        if posicoes_iguais(e, p):
            return True
    return False


def eh_posicao_obstaculo(m, p):
    """prado × posicao → booleano
    Devolve True apenas no caso da posição "p" do prado corresponder "a" uma montanha ou rochedo."""

    for e in m[1]:
        if posicoes_iguais(e, p):
            return True
    if obter_pos_x(p) == 0 or obter_pos_y(p) == 0 or obter_pos_x(p) == obter_pos_x(m[0]) or \
            obter_pos_y(p) == obter_pos_y(m[0]):
        # verifica os limites do prado
        return True
    return False


def eh_posicao_livre(m, p):
    """prado × posicao → booleano
    Devolve True apenas no caso da posição "p" do prado corresponder a um espaço livre (sem animais, nem obstáculos)."""

    if eh_posicao_animal(m, p) or eh_posicao_obstaculo(m, p):
        return False
    return True


def prados_iguais(p1, p2):
    """prado × prado → booleano
    Devolve True apenas se "p1" e "p2" forem prados e forem iguais."""

    if not eh_prado(p1) or not eh_prado(p2):
        return False
    elif p1 != p2:
        return False
    return True


def prado_para_str(m):
    """prado → str
    Devolve uma cadeia de caracteres que representa o prado."""

    s = ""
    s += "+" + "-" * (obter_tamanho_x(m) - 2) + "+\n"  # linha inicial
    for i in range(obter_tamanho_y(m) - 2):
        s += "|"  # limites laterais
        for e in range(obter_tamanho_x(m) - 2):
            # linhas intermédias
            pos = cria_posicao(e + 1, i + 1)
            if eh_posicao_obstaculo(m, pos):
                s += "@"
            elif eh_posicao_livre(m, pos):
                s += "."
            elif eh_posicao_animal(m, pos):
                s += f"{animal_para_char(obter_animal(m, pos))}"
        s += "|\n"
    s += "+" + "-" * (obter_tamanho_x(m) - 2) + "+"  # linha final
    return s


def obter_valor_numerico(m, p):
    """prado × posicao → int
    Devolve o valor numérico da posição "p" correspondente à ordem de leitura no prado "m"."""

    return (obter_tamanho_x(m)) * obter_pos_y(p) + obter_pos_x(p)


def obter_movimento(m, p):
    """prado × posicao → posicao
    Devolve a posição seguinte do animal na posição "p" dentro do prado "m"."""

    y = obter_posicoes_adjacentes(p)
    if eh_presa(obter_animal(m, p)):
        lst = list(filter(lambda x: eh_posicao_livre(m, x), y))  # filtrar as posições livres à volta da presa
        if len(lst) != 0:
            z = obter_valor_numerico(m, p) % len(lst)
            return lst[z]
        else:
            return p
    elif eh_predador(obter_animal(m, p)):
        lst3 = list(filter(lambda x: eh_posicao_animal(m, x), y))  # filtrar as posições com animais à volta
        lst = list(filter(lambda x: eh_presa(obter_animal(m, x)), lst3))  # filtrar se essas posições têm presas
        if len(lst) == 0:
            lst2 = list(filter(lambda x: eh_posicao_livre(m, x), y))  # filtrar as posições livres à volta da presa
            if len(lst2) != 0:
                z = obter_valor_numerico(m, p) % len(lst2)
                return lst2[z]
            else:
                return p
        z = obter_valor_numerico(m, p) % len(lst)
        return lst[z]


# 2.2.1

def geracao(m):
    """prado → prado
    Modifica o prado "m" fornecido como argumento de acordo com a evolução correspondente a uma
    geração completa, e devolve o próprio prado. Isto é, seguindo a ordem de leitura do prado, cada animal (vivo)
    realiza o seu turno de ação de acordo com as regras descritas."""

    move = obter_posicao_animais(m)
    lst = []
    for e in move:
        if not any(posicoes_iguais(x, e) for x in lst):
            x = obter_animal(m, e)
            y = obter_movimento(m, e)
            lst += [y]
            if eh_presa(x):  # presa aumenta a idade
                aumenta_idade(x)
            elif eh_predador(x):
                aumenta_idade(x)  # predador aumenta a idade e a fome
                aumenta_fome(x)
                if eh_posicao_animal(m, y):  # predador deixa de estar faminto e come a presa
                    reset_fome(x)
                    eliminar_animal(m, y)
                if eh_animal_faminto(x):  # faminto e não come presa, morre
                    eliminar_animal(m, e)
            if not eh_posicao_livre(m, e):
                m = mover_animal(m, e, y)
            if eh_posicao_livre(m, e):  # reproduz-se apenas se se mexer
                if eh_animal_fertil(x):
                    inserir_animal(m, reproduz_animal(x), e)
    return m


# 2.2.2

def simula_ecossistema(f, g, v):
    """str × int × booleano → tuplo
    A função recebe uma cadeia de caracteres "f", um valor inteiro "g" e um valor booleano "v" e devolve o tuplo de dois
    elementos correspondentes ao número de predadores e presas no prado no fim da simulação. O argumento booleano "v"
    ativa o modo verboso (True) ou o modo quiet (False). No modo quiet mostra-se pela saída standard o prado,
    o número de animais e o número de geração no início da simulação e após a última
    geração. No modo verboso, após cada geração, mostra-se também o prado, o número de
    animais e o número de geração, apenas se o número de animais predadores ou presas se tiver alterado."""

    fe = open(f, "r")
    linha = fe.readlines()
    dim = cria_posicao(eval(linha[0])[0], eval(linha[0])[1])  # verificação das dimensões
    obs = tuple([cria_posicao(x[0], x[1]) for x in eval(linha[1])])  # verificação dos obstáculos
    an = tuple([cria_animal(eval(x)[0], eval(x)[1], eval(x)[2]) for x in linha[2:]])  # verificação dos animais
    pos = tuple([cria_posicao(eval(x)[3][0], eval(x)[3][1]) for x in linha[2:]])  # verificação das posições dos animais
    prado = cria_prado(dim, obs, an, pos)  # criação do prado
    fe.close()
    if not v:
        print(
            f"Predadores: {obter_numero_predadores(prado)} vs Presas: {obter_numero_presas(prado)} (Gen. 0)")
        print(prado_para_str(prado))
        for e in range(g):
            geracao(prado)
        print(
            f"Predadores: {obter_numero_predadores(prado)} vs Presas: {obter_numero_presas(prado)} (Gen. {g})")
        print(prado_para_str(prado))
    else:
        predadores, presas = obter_numero_predadores(prado), obter_numero_presas(prado)
        print(
            f"Predadores: {obter_numero_predadores(prado)} vs Presas: {obter_numero_presas(prado)} (Gen. 0)")
        print(prado_para_str(prado))
        for e in range(g):
            geracao(prado)
            if obter_numero_predadores(prado) != predadores or obter_numero_presas(prado) != presas:
                print(
                    f"Predadores: {obter_numero_predadores(prado)} vs Presas: {obter_numero_presas(prado)} (Gen. {e + 1})"
                )
                print(prado_para_str(prado))
                predadores, presas = obter_numero_predadores(prado), obter_numero_presas(prado)
    return (obter_numero_predadores(prado), obter_numero_presas(prado))
