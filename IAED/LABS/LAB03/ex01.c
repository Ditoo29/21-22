#include <stdio.h>


void quadrado(int n)
{
    int i,j;

    if(n < 2)
    {
        return;
    }

    for(i=0; i<n; i++)
    {
        for(j=0; j<n; j++)
        {
            if(j>0)
            {
                putchar('\t');
            }
            printf("%d", i+j+1);
            if(j==n-1)
            {
                putchar('\n');
            }
        }
    }
}


int main()
{
    int n;

    scanf("%d", &n);
    quadrado(n);

    return 0;
}