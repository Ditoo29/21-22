#include <stdio.h>

int main()
{
    int n, i;
    float x, sum=0, media;

    scanf("%d", &n);
    for (i=0; i<n; i++)
    {
        scanf("%f", &x);
        sum += x;
    }

    media=(sum/n);
    printf("%.2f\n", media);
    return 0;
}