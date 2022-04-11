#include<stdio.h>

void f(long *a, int *i)
{
    int j;
    for (j=0; j<2; j++)
        a[(*i)++] = (long)(a+j);
}

int main()
{
    int i, j;
    long a[5] = {0};

    for (i=0; i<2; i++)
        a[i]=2*i;

    printf("%ld %lu\n", (long)a, sizeof(long));
    for (j=0; j<5; j++)
        printf("%ld ", a[j]);
    puts("\n");

    f(a, &i);

    for (j = 0; j < 5; j++)
    {
        printf("%ld ", a[j]);
    }
    printf("\n");

    return 0;
}