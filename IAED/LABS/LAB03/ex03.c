#include <stdio.h>


void cruz(int n)
{
    int linhas, colunas;

    for(linhas=0; linhas<n;linhas++)
    {
        for(colunas=0; colunas<n; colunas++)
        {
            if(colunas>0)
            {
                putchar(' ');
            }
            if(linhas==colunas || linhas+colunas==n-1)
            {
                putchar('*');               
            }
            else
            {
                putchar('-');
            }  
            if (colunas==n-1)
            {
                putchar('\n');
            }         
        }
    }
}


int main()
{
    int n;

    scanf("%i", &n);
    cruz(n);

    return 0;
}