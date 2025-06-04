#include <stdio.h>
#include <stdlib.h>

const char *prompt(const char *text, int inputsize) {
  printf("%s", text);
  char *input = malloc(inputsize * sizeof(char));
  if (input == NULL) { // malloc failed, as cautious as zig!
    perror("malloc failed in prompt");
    return NULL;
  }
  if (fgets(input, inputsize, stdin) == NULL) {
    free(input);
    return NULL;
  }
  size_t len = 0;
  while (input[len] != '\0' && input[len] != '\n') {
    len++; // risky, but every code has faults :-D
  }
  if (input[len] == '\n') { // gemini adviced to do this
    input[len] = '\0';
  }
  return input;
}

void free_prompt_input(char *ptr) {
  if (ptr != NULL) {
    free(ptr);
  }
}
