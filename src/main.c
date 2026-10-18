#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>

int main(void){
    char *line = NULL;
    size_t len = 0;

    fputs("myshell$ ", stdout); // puts a prompt to the standard output. fputs compared to puts has no \n.
    fflush(stdout);             // flushes the output buffer to ensure that the prompt is displayed immediately
                                // skips the buffering by flushing the queue, kinda.

    ssize_t read = getline(&line, &len, stdin); // reads from standard input, stdin, and stores input in line
                                                // getline returns number of chars read, or -1 on failure.

    // if length of line is greater than 0, then print the line
    if (read > 0) {
        printf("Your input: %s", line);
    }

    free(line); // free the memory allocated for line to avoid memory leaks

    return 0;
}