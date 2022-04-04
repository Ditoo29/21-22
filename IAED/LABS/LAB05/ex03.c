#include <stdio.h>

#define max_v 80

void maiusculas(char s[])
{
    int c=0;

    while (s[c] != '\0')
    {
        if(s[c] >= 'a' && s[c]<= 'z')
        {
            s[c] = s[c] - 'a' + 'A';
            c++;
        }
        else
        {
            c++;
        }        
    }
}

int leLinha(char s[])
{
    int i=0, c;

    while ((c=getchar()) != '\n' && c != EOF)
    {
        s[i] = c;
        i++;
    }
    s[i] = '\0';
    return 0;  
} 

int main()
{
    char vetor[max_v];
    leLinha(vetor);
    maiusculas(vetor);
    printf("%s\n", vetor);
    return 0;
}