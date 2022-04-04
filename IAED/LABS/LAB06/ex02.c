/* Resolução RafDevX */
#include <stdio.h>

struct complexo {
	float real;
	float imag;
};

int main()
{
	struct complexo c1, c2, s;

	scanf("%f%fi", &(c1.real), &(c1.imag));
	scanf("%f%fi", &(c2.real), &(c2.imag));

	s.real = c1.real + c2.real;
	s.imag = c1.imag + c2.imag;

	printf("%.2f%s%.2fi", s.real, s.imag < 0 ? "" : "+", s.imag);
	return 0;
}