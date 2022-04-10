#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int *v;
	int cap;
	int sz;
} stack;

stack *init()
{
	stack *s;
	s = malloc(sizeof(stack));
	s->cap = 4;
	s->sz = 0;
	s->v = malloc(sizeof(int) * s->cap);
	return s;
}

void push(stack *s, int e)
{
	if(s->cap == s->sz){
		s->cap++;
		s->v = realloc(s->v, sizeof(int) * s->cap);
	}
    s->v[s->sz] = e;
	s->sz++;
}

int pop(stack *s)
{
	return s->v[--s->sz];
}

int is_empty(stack *s)
{
	if(s->sz == 0)
        return 1;
    else
        return 0;
}

void destroy(stack *s)
{
	free(s);
}

int main()
{
    int e;
	stack *s = init();

	while(scanf("%d", &e) == 1)
    {
        push(s, e);
    }

    while (is_empty(s) == 0)
    {
        printf("%d\n", pop(s));
    }    

    destroy(s);
	return 0;
}