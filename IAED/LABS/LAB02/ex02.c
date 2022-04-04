#include <stdio.h>

int main()
{
    int n,i,d=0;

    printf("? ");
    scanf("%d", &n);

    if(n > 0)
    {
        i = 2;
        while(i <= n / 2)
        {
            if(n % i == 0)
            {
                printf("%d é divisível por %d\n", n, i);
                d = d+1;
            }
            i = i+1;
        }
        if(d == 0)
            printf("%d é primo.\n", n);
    }
    return 0;
}