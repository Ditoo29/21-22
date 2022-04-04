#include <stdio.h>

#define MAX_NAME_SIZE 11
#define MAX_TITULOS 1000

struct Stock {
	char nome[MAX_NAME_SIZE];
	float valor;
	float taxa;
};

int main()
{
	int N, i;
	struct Stock vec[MAX_TITULOS];
	struct Stock melhor;
	float rend, melhorRend = 0;

	scanf("%d", &N);

	for (i = 0; i < N; i++) {
		scanf("%s%f%f", vec[i].nome, &(vec[i].valor), &(vec[i].taxa));
	}

	for (i = 0; i < N; i++) {
		rend = vec[i].valor * (1 + vec[i].taxa);
		if (rend > melhorRend) {
			melhor = vec[i];
			melhorRend = rend;
		}
	}

	printf("%s %.2f %.2f\n", melhor.nome, melhor.valor, melhor.taxa);

	return 0;
}