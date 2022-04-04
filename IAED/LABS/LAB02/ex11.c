#include <stdio.h>

int main()
{
    int n, d, c=0, s=0;

    scanf("%d", &n);
    while (n!=0)
    {
        d = n%10;
        c++;
        s = s+d;
        n = n/10;
    }

    printf("%d\n", c);
    printf("%d\n", s);
    return 0;

}