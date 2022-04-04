#include <stdio.h>


void piramide(int n)
{
    int i, j, m, o;

    for (i=1; i<=n; i++)
    {
        for (j=0; j<n-i; j++)
        {
            putchar(' ');
            putchar(' ');
        }
        for (m=1; m<=i; m++)
        {
            printf("%d", m);
            if (i!=1)
                putchar(' ');
        }
        for (o=i-1; o>0; o--)
        {
            printf("%d", o);
            if (o!=1)
                putchar(' ');
        }
        putchar('\n');
    }
}

int main()
{
    int n;

    scanf("%d", &n);
    piramide(n);
    return 0;
}