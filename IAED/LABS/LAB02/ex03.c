#include <stdio.h>

int main()
{
    int a,b,m,d=1,i=2;

    printf("? ");
    scanf("%d", &a);
    printf("? ");
    scanf("%d", &b);

    if(a <= 0 || b <= 0)
        printf("Os números devem ser inteiros positivos\n");
    else
    {
        m = a;
        d = 1;
        i = 2;
        if(a > b)
            m = b;
        while (i <= m)
        {
            if(a % i == 0 && b % i == 0)
                d = i;
            i = i+1;
        }
        printf("%d é o maior divisor comum entre %d e %d\n", d, a, b);
        
    }

    return 0;
}
