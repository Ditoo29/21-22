#include <stdio.h>

int main()
{
    int n, i, c;

    scanf("%d", &n);
    c = 1;

    for (i=1; i<n; i++)
    {
        if (n%i == 0)
        {
            c++;
        }
    }
    printf("%d\n", c);
    return 0;
}