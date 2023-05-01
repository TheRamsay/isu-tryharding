#include <stdio.h>
#include <stdlib.h>

int fib(int n, int *arr) {
    if (n == 0) {
        arr[n] = 0;
        return 0;
    }

    if (n == 1) {
        arr[n] = 1;
        return 1;
    }

    int result = arr[n - 1] == 0 ? fib(n - 1, arr) : arr[n - 1];
    result += arr[n - 2] == 0 ? fib(n - 2, arr) : arr[n - 2];

    arr[n] = result;
    return result;
}

int main() {
    int *arr = malloc(sizeof(int) * 6);
    if (arr == NULL) {
        fprintf(stderr, "Allocation error.\n");
        return EXIT_FAILURE;
    }

    fib(5, arr);

    for (size_t i = 0; i < 20; i++)
    {
        printf("%d) %d\n", i + 1, arr[i]);
    }
    
    free(arr);
}