#include <stdio.h>

int main()
{
    int n,m,i,max;

    scanf("%d %d", &n, &m);
    if (n>m)
    {
        for (i=1; i<=m; i++)
        {
            if (n%i==0 && m%i==0)
            {
                max = i;
            }            
        }
    }
    else if (n<m)
    {
        for (i=1; i<=n; i++)
        {
            if (n%i==0 && m%i==0)
            {
                max = i;
            }            
        }
    }
    else
        max = n;
    printf("%d\n", max);
    return 0;    
}