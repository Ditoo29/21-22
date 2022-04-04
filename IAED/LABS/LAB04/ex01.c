#include <stdio.h>

int main()
{
    int n,i,m; 
    int vec[100];
    scanf("%d", &n);

    for (i=0; i<n; i++)
    {
        scanf("%d", &vec[i]);
        for(m=0; m<vec[i]; m++)
        {
            putchar('*');
        }
        putchar('\n');
    }
    return 0;
}