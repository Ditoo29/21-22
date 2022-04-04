#include <stdio.h>

int main()
{
    int n, i, j, max=0;
    int vec[100];

    scanf("%d", &n);

    for (i=0; i<n; i++)
    {
        scanf("%d",&vec[i]);
        if(vec[i] > max)
            max = vec[i];
    }

    for (i=max; i>=1;i--)
    {
        for (j=0; j<n; j++)
        {
            if(vec[j]>=i)
                putchar('*');
            else 
                putchar(' ');
        }
        putchar('\n');
    }
    return 0;
}