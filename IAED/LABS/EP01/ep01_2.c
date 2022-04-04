#include <stdio.h>
#include <stdlib.h>
#define MK 01
int c(unsigned int n) {
    unsigned int j = MK;
    int r = 0, m = -1;
    for (r = 0; j; j <<= 1, r++)
        if ((j & n) != 0)
            m = r;
    return m;
}

int main() {
    printf("%d\n", c(10));
    return 0;
}