#include <stdio.h>

int main()
{
    int n,i,j, min, middle, max;
    scanf("%d%d%d", &n,&i,&j);

    if(n>i)
    {
        if(n>j)
        {
            if (i>j)
            {
                max = n;
                middle = i;
                min = j;
            }
            else
            {
                max = n;
                middle = j;
                min = i;
            }
        }
        else
        {
            max = j;
            middle = n;
            min = i;
        }
    }
    else
    {
        if (i>j)
        {
            if (n>j)
            {
                max = i;
                middle = n;
                min = j;
            }
            else
            {
                max = i;
                middle = j;
                min = n;
            }
        }
        else
        {
            max = j;
            middle = i;
            min = n;
        }
    }

    printf("%d ", min);
    printf("%d ", middle);
    printf("%d\n", max);
    return 0;
}