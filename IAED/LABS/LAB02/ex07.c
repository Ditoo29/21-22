#include <stdio.h>

int main()
{   
    int i, n;
    float max, min, j;

    scanf("%d", &n);

    for (i = 0; i < n; i++)
    {
        scanf("%f", &j);
        if (i == 0)
        {
            max = j;
            min = j;
        }
        if (j < min)
        {
            min = j;
        }
        if (j > max)
        {
            max = j;
        }
    }

    printf("min: %f, max: %f\n", min, max);
    return 0;
}