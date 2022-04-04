#include <stdio.h>

int main()
{
	int n = 0;
	char c;
	while ((c = getchar()) != EOF) 
    {
		if (c == '\n' || c == ' ') 
        {
			if (n == 0) 
            {
				putchar('0');
			}
			n = 0;
			putchar(c);
		} 
        else 
        {
			if (c != '0' || n == 1) 
            {
				n = 1;
				putchar(c);
			}
		}
	}
	if (n == 0) 
    {
		putchar('0');
	}
	return 0;
}