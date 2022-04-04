#include <stdio.h>

#define max 100

int main()
{
    char s1[max], s2[max];
    int i=0;

    scanf("%s %s", s1, s2);

    while (s1[i] != '\0')
    {
        if (s1[i] > s2[i])
        {
            printf("%s\n", s1);
            return 0;
        }
        else if (s1[i] < s2[i])
        {
            printf("%s\n", s2);
            return 0;
        }
        i++;        
    }

    return 0;    
}