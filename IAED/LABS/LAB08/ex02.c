#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	char c[1000];
	char *p, *palavra[10000];
	int sz = 0;
	while (scanf("%s", c) == 1) {
		p = malloc(sizeof(char) * (strlen(c) + 1));
		strcpy(p, c);
		palavra[sz] = p;
        sz++;
	}
    sz--;
	while (sz >= 0) {
		printf("%s\n", palavra[sz]);
		free(palavra[sz]);
        sz--;
	}
	return 0;
}