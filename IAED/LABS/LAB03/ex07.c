#include <stdio.h>

int main()
{
    char c;
    int n=0, soma=0, op=1;

    while ((c=getchar()) != '\n')
    {
        if (c>='0' && c<='9')
        {
            n = n*10 + (c - '0');
        }
        else
        {
            if (c=='+')
                op = 1;
            else if (c=='-')
                op = 0;
            if (op==1)           
                soma += n;           
            else if (op==0)
                soma -= n;
            n = 0;
        }
    }
    if (op==1)           
        soma += n;           
    else if (op==0)
        soma -= n;
    printf("%d\n", soma);
    return 0;
}