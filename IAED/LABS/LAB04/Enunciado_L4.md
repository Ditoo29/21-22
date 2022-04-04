# Manipulação de vectores/tabelas

*Nota prévia:* Quando trabalhamos com vectores em C, é comum fazer erros que levam a [Segmentation Faults](https://en.wikipedia.org/wiki/Segmentation_fault). Se obtiver tal erro nos exercícios abaixo provavelmente terá uma gralha nos limites dos seus ciclos, ou seja, deverá estar a tentar aceder a um elemento de um vector que não existe.
Podem usar o programa `valgrind` para tentar identificar o problema.

---

## ex01

(Gráfico horizontal) Escreva um programa que peça ao utilizador um número inteiro positivo `n < VECMAX`, onde `VECMAX=100`. Depois, leia `n` números inteiros positivos. No final o programa deverá escrever uma representação gráfica dos valores lidos como o que se segue. O gráfico apresentado é o exemplo para `n = 3` e valores `1 3 4`.

```
*
***
****
```

## ex02

(Gráfico vertical suspenso) Escreva um programa que peça ao utilizador um número inteiro positivo `n < VECMAX`, onde `VECMAX=100`. Depois, leia `n` números inteiros positivos. No final o programa deverá escrever uma representação gráfica dos valores lidos como o que se segue. O gráfico apresentado é o exemplo para `n = 3` e valores `1 3 4`.

```
***
 **
 **
  *
```

## ex03

(Gráfico vertical crescente) Escreva um programa que peça ao utilizador um número inteiro positivo `n < VECMAX`, onde `VECMAX=100`. Depois, leia `n` números inteiros positivos. No final o programa deverá escrever uma representação gráfica dos valores lidos como o que se segue. O gráfico apresentado é o exemplo para `n = 3` e valores `1 3 4`.

```
  *
 **
 **
***
```

## ex04
(Soma cumulativa) Escreva um programa que peça ao utilizador um número inteiro positivo `n < VECMAX`, onde `VECMAX=100`. Depois, leia `n` números reais em precisão dupla.
Escreva a função, `soma_cumulativa`, que recebe o vetor anteriormente lido e a sua dimensão e altera o vetor de tal forma que cada elemento resulta da soma cumulativa de todos os elementos do vetor que o antecedem, ou
seja, o elemento na posição i do vetor devolvido contém a soma de todos os
elementos do vetor original nas posições de 0 a i.
No final o programa deverá escrever os elementos do vetor resultante numa só linha e separados por um espaço branco.

## ex05
Uma chave do euromilhões é constituída por cinco inteiros,
entre 1 e 50 e sem repetições e por dois números diferentes
entre 1 e 12.
Escreva um programa que imprime uma chave aleatória do euromilhões.
Para a geração de números aleatórios utilize a função `rand()`,
declarada em `stdlib.h` , que devolve aleatoriamente um número
inteiro no intervalo `[0, RAND_MAX[`.
Para gerar sequências aleatórias distintas inicie o gerador `srand(n)`
com um número inteiro `n` lido do terminal.

## ex06
(Remove múltiplos) Escreva um programa que peça ao utilizador um número inteiro positivo `n < VECMAX`, onde `VECMAX=100`. Depois, leia `n` números inteiros positivos.
Depois pede ao utilizador um último número inteiro.
No final o programa deverá escrever uma lista que resulta de remover
todos os múltiplos do último número lido da lista lista de valores inicialmente lida.
