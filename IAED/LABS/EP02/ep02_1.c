#include <stdio.h>

double polyval(double pol[], int size, double x)
{
    double s=0, c=1;
    int i, j;

    for (i=0; i<size; i++)
    {
        for (j=0; j<i; j++)
        {
            c *= x;
        }

        s += c*pol[i];
        c = 1;
    }

    return s;

}

int main()  /* Não era necessario escrever a main */
{
    double pol[] = {1, 2, 3};
    printf("%g\n", polyval(pol, 3, 2));
    return 0;
}