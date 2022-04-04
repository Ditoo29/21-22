# 1.2.1
def corrigir_palavra(palavra):
    """ corrigir palavra: cad. carateres → cad. carateres

    Esta função recebe uma cadeia de carateres que representa uma palavra (potencialmente
    modificada por um surto de letras) e devolve a cadeia de carateres que corresponde à
    aplicação da sequência de reduções conforme descrito para obter a palavra corrigida. """

    restart = True
    repeticao = ["aA", "bB", "cC", "dD", "eE", "fF", "gG", "hH", "iI", "jJ", "kK", "lL", "mM", "nN", "oO", "pP", "qQ",
                 "rR", "sS", "tT", "uU", "vV", "wW", "xX", "yY", "zZ", "Aa", "Bb", "Cc", "Dd", "Ee", "Ff", "Gg", "Hh",
                 "Ii", "Jj", "Kk", "Ll", "Mm", "Nn", "Oo", "Pp", "Qq", "Rr", "Ss", "Tt", "Uu", "Vv", "Ww", "Xx", "Yy",
                 "Zz"]
    while restart:  # utilizado para continuar e reiniciar a verificação após a deteção de um caso
        restart = False
        for i in repeticao:
            if i in palavra:
                palavra = palavra.replace(i, "")
                restart = True
    return palavra


# 1.2.2
def eh_anagrama(p1, p2):
    """ eh anagrama: cad. carateres × cad. carateres → booleano

    Esta função recebe duas cadeias de carateres correspondentes a duas palavras e devolve
    True se e só se uma é anagrama da outra. """

    p1 = p1.lower()
    p2 = p2.lower()
    if sorted(p1) == sorted(p2):
        return True
    else:
        return False


# 1.2.3
def corrigir_doc(texto):
    """ corrigir doc: cad. carateres → cad. carateres

    Esta função recebe uma cadeia de carateres que representa o texto com erros da documentação da BDB e
    devolve a cadeia de carateres filtrada com as palavras corrigidas e os anagramas retirados, ficando apenas a sua
    primeira ocorrência. Os anagramas são avaliados após a correção das palavras e apenas são retirados
    anagramas que correspondam a palavras diferentes. """

    if type(texto) != str:
        raise ValueError("corrigir_doc: argumento invalido")
    elif not all(c.isalpha() or c.isspace() for c in texto):
        raise ValueError("corrigir_doc: argumento invalido")
    elif "  " in texto:
        raise ValueError("corrigir_doc: argumento invalido")
    elif len(texto) < 1:
        raise ValueError("corrigir_doc: argumento invalido")

    texto = (corrigir_palavra(texto))
    texto = list(texto.split(" "))  # criação da lista de apoio dividindo a string em cada espaço ocorrido

    for i in range(len(texto)):
        for j in range(i + 1, len(texto) - 1):
            if eh_anagrama(texto[i], texto[j]) and texto[i].lower() != texto[j].lower():
                # verificação dos anagramas entre todas os elementos da lista, desde que não sejam iguais
                del texto[j]
    for i in range(len(texto) - 1):
        if eh_anagrama(texto[len(texto) - 1], texto[i]) and texto[len(texto) - 1].lower() != texto[i].lower():
            # verificação do último elemento da lista
            del texto[len(texto) - 1]

    texto = " ".join(texto)  # utilizado para unir a lista como string novamente
    return texto


# 2.2.1
def obter_posicao(direcao, inteiro):
    """ obter posicao: cad. carateres × inteiro → inteiro

    Esta função recebe uma cadeia de carateres contendo apenas um caráter que representa
    a direção de um único movimento ("C", "B", "E" ou "D") e um inteiro representando a
    posição atual (1, 2, 3, 4, 5, 6, 7, 8 ou 9); e devolve o inteiro que corresponde à nova
    posição após do movimento. """

    if direcao == "C" and inteiro > 3:
        inteiro -= 3
    elif direcao == "B" and inteiro < 7:
        inteiro += 3
    elif direcao == "D":
        if inteiro < 3 or 3 < inteiro < 6 or 6 < inteiro < 9:
            inteiro += 1
    elif direcao == "E":
        if 1 < inteiro < 4 or 4 < inteiro < 7 or 7 < inteiro:
            inteiro -= 1
    return inteiro


# 2.2.2
def obter_digito(sequencia, inteiro):
    """ obter digito: cad. carateres × inteiro → inteiro

    Esta função recebe uma cadeia de carateres contendo uma sequência de um ou mais movimentos e um inteiro
    representando a posição inicial; e devolve o inteiro que corresponde ao dígito a marcar após finalizar todos
    os movimentos. """

    sequencia = tuple(sequencia)
    for i in sequencia:
        inteiro = obter_posicao(i, inteiro)
    return inteiro


# 2.2.3
def obter_pin(tup1):
    """ obter pin: tuplo → tuplo

    Esta função recebe um tuplo contendo entre 4 e 10 sequências de movimentos e devolve o tuplo de inteiros que
    contêm o pin codificado de acordo com o tuplo de movimentos. """

    if type(tup1) != tuple:
        raise ValueError("obter_pin: argumento invalido")
    elif len(tup1) < 4 or len(tup1) > 10:
        raise ValueError("obter_pin: argumento invalido")

    casa = 5  # casa inicial para a sequência
    l1 = list()  # lista criada para dar store às casas obtidas após cada sequência de movimentos
    for i in tup1:

        if len(i) < 1:
            raise ValueError("obter_pin: argumento invalido")

        for c in i:
            if c != "C" and c != "E" and c != "D" and c != "B":
                raise ValueError("obter_pin: argumento invalido")

        casa = obter_digito(i, casa)
        l1.append(casa)
    tup2 = tuple(l1)  # retornar a lista criada num tuplo
    return tup2


# 3.2.1 / 4.2.1
def eh_entrada(tuplo):
    """ eh entrada: universal → booleano

    Esta função recebe um argumento de qualquer tipo e devolve True se e só se o seu
    argumento corresponde a uma entrada da BDB (potencialmente corrupta) conforme
    descrito, isto é, um tuplo com 3 campos: uma cifra, uma sequência de controlo e uma
    sequência de segurança. """

    if type(tuplo) != tuple:
        return False
    if len(tuplo) != 3:
        return False

    cifra = tuplo[0]  # primeiro elemento do tuplo correspondente à cifra
    checksum = tuplo[1]  # segundo elemento do tuplo correspondente ao checksum
    seg = tuplo[2]  # terceiro elemento do tuplo correspondente ao número de segurança

    if type(cifra) != str:
        return False
    elif cifra.isupper():
        return False
    elif not all(c.isalpha() or c == "-" for c in cifra):
        return False
    elif len(cifra) < 1:
        return False
    elif cifra[0] == "-":
        return False
    elif cifra[len(cifra) - 1] == "-":
        return False
    for e in range(len(cifra) - 1):
        if cifra[e] == cifra[e + 1] and cifra[e] == "-":
            return False

    if type(checksum) != str:
        return False
    elif len(checksum) != 7:
        return False
    elif not checksum[1:6].isalpha():
        return False
    elif not checksum[1:6].islower():
        return False
    elif checksum[0] != "[":
        return False
    elif checksum[6] != "]":
        return False

    if type(seg) != tuple:
        return False
    elif len(seg) < 2:
        return False
    for i in seg:
        if type(i) != int or i < 0:
            return False

    return True


# 3.2.2
def validar_cifra(cifra, checksum):
    """ validar cifra: cad. carateres × cad. carateres → booleano

    Esta função recebe uma cadeia de carateres contendo uma cifra e uma outra cadeia de
    carateres contendo uma sequência de controlo, e devolve True se e só se a sequência de
    controlo é coerente com a cifra conforme descrito. """

    letras = "abcdefghijklmnopqrstuvwxyz"
    d = {}

    for c in letras:
        count = cifra.count(c)  # utilizado para contar a aparência de cada letra na cifra
        if count >= 1:
            d[c] = cifra.count(c)  # adicionar o elemento ao dicionário se existir pelo menos uma vez

    if checksum[1] != max(d, key=d.get):
        return False
    del d[max(d, key=d.get)]  # processo feito várias vezes, que consiste em descartar o valor do dicionário após ser
    # utilizado

    if checksum[2] != max(d, key=d.get):
        return False
    del d[max(d, key=d.get)]

    if checksum[3] != max(d, key=d.get):
        return False
    del d[max(d, key=d.get)]

    if checksum[4] != max(d, key=d.get):
        return False
    del d[max(d, key=d.get)]

    if checksum[5] != max(d, key=d.get):
        return False
    del d[max(d, key=d.get)]

    return True


# 3.2.3
def filtrar_bdb(lst):
    """  filtrar bdb: lista → lista

    Esta função recebe uma lista contendo uma ou mais entradas da BDB e devolve apenas a lista contendo as
    entradas em que o checksum não é coerente com a cifra correspondente, na mesma ordem da lista original. """

    newlist = []  # nova lista de apoio
    if type(lst) != list:
        raise ValueError("filtrar_bdb: argumento invalido")
    if len(lst) < 1:
        raise ValueError("filtrar_bdb: argumento invalido")

    for i in lst:
        if not eh_entrada(i):
            raise ValueError("filtrar_bdb: argumento invalido")
        if not validar_cifra(i[0], i[1]):
            newlist += [i]
    return newlist


# 4.2.2
def obter_num_seguranca(seg):
    """ obter num seguranca: tuplo → inteiro

    Esta função recebe um tuplo de números inteiros positivos e devolve o número de segurança conforme
    descrito, isto é, a menor diferença positiva entre qualquer par de números. """

    dif = 10 ** 1000  # numero que corresponde a infinito de modo a ser a diferença inicial

    for i in range(len(seg) - 1):
        for j in range(i + 1, len(seg)):
            if abs(seg[i] - seg[j]) < dif:
                dif = abs(seg[i] - seg[j])  # utilizado o valor absoluto em todas as diferenças
    return dif


# 4.2.3
def decifrar_texto(cifra, seg):
    """ decifrar texto: cad. carateres × inteiro → cad. carateres

    Esta função recebe uma cadeia de carateres contendo uma cifra e um número de segurançaa, e devolve o texto
    decifrado conforme descrito. """

    newcifra = ""  # nova string para dar store ao output
    for i in range(len(cifra)):

        number = ord(cifra[i]) - 96  # number corresponde às letras do alfabeto ordenadas do 1 ao 26

        if cifra[i] == "-":
            newcifra += " "
        elif i % 2 == 0:
            inc = ((seg % 26) + 1)  # inc é o número que será responsável pela transformação da letra
            if (number + inc) != 26:
                newcifra += chr(((number + inc) % 26) + 96)  # utilizado o "%26" após soma do number com o inc para
                # corrigir casos em que a soma é superior a 26, voltando ao início do alfabeto quando ultrapassado
            else:
                newcifra += chr((number + inc) + 96)
        elif i % 2 == 1:
            inc = ((seg % 26) - 1)
            if (number + inc) != 26:
                newcifra += chr(((number + inc) % 26) + 96)  # repete-se o mesmo processo com um inc diferente no caso
                # ímpar
            else:
                newcifra += chr((number + inc) + 96)

    return newcifra


# 4.2.4
def decifrar_bdb(lst):
    """ decifrar bdb: lista → lista

    Esta função recebe uma lista contendo uma ou mais entradas da BDB e devolve uma
    lista de igual tamanho, contendo o texto das entradas decifradas na mesma ordem. """

    if type(lst) != list:
        raise ValueError("decifrar_bdb: argumento invalido")

    newlist = []  # nova lista utilizada para dar store ao output
    for i in lst:
        if not eh_entrada(i):
            raise ValueError("decifrar_bdb: argumento invalido")

        newlist += [decifrar_texto(i[0], obter_num_seguranca(i[2]))]
    return newlist


# 5.2.1
def eh_utilizador(d):
    """ eh utilizador: universal → booleano

    Esta função recebe um argumento de qualquer tipo e devolve True se e só se o seu
    argumento corresponde a um dicionário contendo a informação de utilizador relevante
    da BDB conforme descrito. """

    if type(d) != dict:
        return False
    elif list(d.keys()) != ["name", "pass", "rule"]:
        return False
    elif type(d["name"]) != str or len(d["name"]) < 1:
        return False
    elif type(d["pass"]) != str or len(d["pass"]) < 1:
        return False

    if list(d["rule"].keys()) != ["vals", "char"]:
        return False
    elif type(d["rule"]) != dict:
        return False
    elif type(d["rule"]["vals"]) != tuple or len(d["rule"]["vals"]) != 2:
        return False
    elif d["rule"]["vals"][0] > d["rule"]["vals"][1]:
        return False
    for i in d["rule"]["vals"]:
        if type(i) != int or i <= 0:
            return False

    if type(d["rule"]["char"]) != str or len(d["rule"]["char"]) != 1:
        return False
    elif not d["rule"]["char"].lower():
        return False

    return True


# 5.2.2
def eh_senha_valida(senha, regras):
    """ eh senha valida: cad. carateres × dicionário → booleano

    Esta função recebe uma cadeia de carateres correspondente a uma senha e um dicionário
    contendo a regra individual de criação da senha, e devolve True se e só se a senha cumpre
    com todas as regras de definição (gerais e individual) conforme descrito. """

    vogais = "aeiou"  # utilizado para verificar as vogais
    c = 0  # contador de vogais
    p = 0  # contador de letras consecutivas
    if type(senha) != str:
        return False
    elif type(regras) != dict:
        return False

    if senha.count(regras["char"]) < regras["vals"][0] or senha.count(regras["char"]) > regras["vals"][1]:
        # utilizado para analisar a quantidade de vezes que a letra definida em "char" aparece e está de acordo com os
        # valores em "vals"
        return False
    for i in senha:
        if i in vogais:
            c += 1
    for i in range(len(senha) - 1):
        if senha[i] == senha[i + 1]:
            p += 1
    if c < 3 or p < 1:
        return False

    return True


# 5.2.3
def filtrar_senhas(lista):
    """ filtrar senhas: lista → lista

    Esta função recebe uma lista contendo um ou mais dicionários correspondentes às entradas da BDB como
    descritas anteriormente, e devolve a lista ordenada alfabeticamente com os nomes dos utilizadores com senhas
    erradas. """

    newlista = []  # nova lista utilizada para dar store ao output
    if type(lista) != list or len(lista) < 1:
        raise ValueError("filtrar_senhas: argumento invalido")

    for i in lista:

        if not eh_utilizador(i):
            raise ValueError("filtrar_senhas: argumento invalido")
        elif not eh_senha_valida(i["pass"], i["rule"]):
            newlista.append(i["name"])
    newlista.sort()  # organizar por ordem alfabetica
    return newlista
