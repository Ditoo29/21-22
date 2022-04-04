#include <stdio.h>
#include <string.h>

#define MAX 80

int palindromo(char s[]) {
    int len = strlen(s);
    int l = 0, h = len - 1;
    while (h > l && s[l] == s[h]){
        l++;
        h--;
    }
    return len % 2 == 0 ? h + 1 == l : h == l;
} 

int main(){
    char str[MAX];

    if (scanf("%s", str) < 0){
        printf("yes\n");
    } else {
        printf("%s\n", palindromo(str) ? "yes" : "no");
    } 
    
    return 0;
}