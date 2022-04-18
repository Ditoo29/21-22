#include <stdio.h>

typedef struct next {
    int value;
    struct next *next;
} Next;

int count(Next *head, int val)
{
    int oco;

    while(head != NULL)
    {
        if(head->value == val)
            oco++;
        head = head->next;
    }
    return oco;
}