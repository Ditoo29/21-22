#include <stdio.h>

#define MAX 1001

int main()
{
    char *p, w[MAX];
    scanf("%s", w);
    for(p=w; *p!='\0'; p++)
    {
        printf("%s\n", p);
    }
    return 0;
}