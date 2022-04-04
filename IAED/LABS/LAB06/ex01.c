#include <stdio.h>

#define ALUNOS 10
#define DISCIPLINAS 5

long score_disciplina(int disciplina, int valores[ALUNOS][DISCIPLINAS]);
long score_aluno(int aluno, int valores[ALUNOS][DISCIPLINAS]);

int main()
{
	int N, i, A, D, V, melhorDisc = -1, melhorAluno = -1;
	int valores[ALUNOS][DISCIPLINAS] = {{0}};
	long sc, scoreMelhorDisc, scoreMelhorAluno;

	scanf("%d", &N);
	for (i = 0; i < N; i++) {
		scanf("%d %d %d", &A, &D, &V);
		valores[A][D] = V;
	}

	for (i = 0; i < DISCIPLINAS; i++) {
		sc = score_disciplina(i, valores);
		if (melhorDisc < 0 || sc > scoreMelhorDisc) {
			melhorDisc = i;
			scoreMelhorDisc = sc;
		}
	}

	for (i = 0; i < ALUNOS; i++) {
		sc = score_aluno(i, valores);
		if (melhorAluno < 0 || sc > scoreMelhorAluno) {
			melhorAluno = i;
			scoreMelhorAluno = sc;
		}
	}

	printf("%d\n%d\n", melhorDisc, melhorAluno);

	return 0;
}

long score_disciplina(int disciplina, int valores[ALUNOS][DISCIPLINAS])
{
	long score = 0;
	int i;
	for (i = 0; i < ALUNOS; i++) {
		score += valores[i][disciplina];
	}
	return score;
}

long score_aluno(int aluno, int valores[ALUNOS][DISCIPLINAS])
{
	long score = 0;
	int i;
	for (i = 0; i < DISCIPLINAS; i++) {
		score += valores[aluno][i];
	}
	return score;
}