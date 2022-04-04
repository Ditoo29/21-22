#include <stdio.h>

int main()
{
    int a,b,c;

    printf("? ");
    scanf("%d", &a);
    printf("? ");
    scanf("%d", &b);
    printf("? ");
    scanf("%d", &c);

    if(a<1 || b<1 || c<1)
        printf("As dimensões dos lados do triângulo devem ser todas positivas\n");
    else
    {
        if (a + b <= c || a + c <= b || c + b <= a)
            printf("Não é triângulo\n");
        else
        {
            if (a == b && b == c)
                printf("O triângulo é equilátero\n");
            else
            {
                if (a == b || b == c || c == a)
                    printf("O triângulo é isósceles\n");
                else 
                    printf("O triângulo é escaleno\n");
            }
        }
    }
    return 0;
}