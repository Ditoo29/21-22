#include <stdio.h>

typedef struct next {
    int value;
    struct next *next;
} Next;


link delete(Next *head, int val)
{
    Next *t, *prev;
    for(t=head, prev = NULL; t!=NULL; t=t->next, prev=t)
    {
        if(t->value == val)
        {
            if(t==head)
            {
                head = t->next;
            }
            else
            {
                prev->next = t->next;
            }
            free(t);
        }
    }
    return head;
}