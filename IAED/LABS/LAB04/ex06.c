#include <stdio.h>

#define maxv 100

int main()
{
    int n, i, m, c=0;
    int vetor[maxv], final[maxv];

    scanf("%d", &n);
    for (i=0; i<n; i++)
    {
        scanf("%d", &vetor[i]);
    }
    scanf("%d", &m);

    for(i=0; i<n; i++)
    {
        if(vetor[i]%m != 0)
        {
            final[c] = vetor[i];
            c++;
        }
    }

    if(c == 0)
        printf("\n");
        
    for (i=0; i<c; i++)
    {
        if(i+1 == c)
            printf("%d\n", final[i]);
        else
            printf("%d ", final[i]);
    }
    return 0;
}