#include <stdio.h>

#define max_v 80

void apagaCaracter(char s[], char c)
{
    int i=0;

    while (s[i] != '\0')
    {
        if (s[i] != c)
        {
            printf("%c", s[i]);
        }
        i++;        
    }
    
}

int main()
{
    char c;
    char vetor[max_v];

    fgets(vetor, max_v, stdin);
    scanf("%c", &c);

    apagaCaracter(vetor, c);

    return 0;
}