#include <stdio.h>

int main()
{
    char c;
    int sum;

    while ((c=getchar()) != EOF)
    {
        if(c>'0' && c<='9')
            sum += c - '0';
    }

    if (sum%9==0)
        printf("yes\n");
    else
        printf("no\n");
    
    return 0;
    
}