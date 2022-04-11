#include <stdio.h>

typedef struct 
{
    unsigned lin, col;
    double val;
} Entry;


double **entry2mat(Entry *mat, int n, double zero, unsigned mini, unsigned minj, unsigned maxi, unsigned maxj) 
{
    int i, j;
    double **v = malloc(sizeof(double*)*(maxi-mini+1));
    for (i = 0; i <= maxi-mini; i++) 
    {
        v[i] = malloc(sizeof(double)*(maxj-minj+1));
        for (j = 0; j <= maxj-minj; j++)
            v[i][j] = zero;
    }
    for (i = 0; i < n; i++)
        v[mat[i].lin-mini][mat[i].col-minj] = mat[i].val;
    return v;
}
