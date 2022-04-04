#include <stdio.h>

#define max_v 80

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
    printf("%s\n", vetor);
    return 0;
}