#include <stdio.h>

#define maxvector 100

int main()
{
    int n, i, s=0;
    int vetor[maxvector];

    scanf("%d", &n);
    for (i=0; i<n; i++)
    {
        getchar();
        scanf("%d", &vetor[i]);
    }

    for (i=0; i<n; i++)
    {
        s += vetor[i];
        if (i+1==n)
        {
            printf("%d\n", s);
        }
        else
        {
            printf("%d ", s);
        }        
    }
    return 0;
}

