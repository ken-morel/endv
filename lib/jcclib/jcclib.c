#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

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

void freestr(char *ptr) {
  if (ptr != NULL) {
    free(ptr);
  }
}

int forkcmd(char *cmd) {
  printf("forking %s\n", cmd);
  pid_t pid = fork();

  if (pid == -1) {
    perror("fork");
    return -1;
  } else if (pid == 0) { // Child process
    // Tokenize the command string
    char *args[256]; // Assuming a maximum of 256 arguments
    int i = 0;
    char *token = strtok(cmd, " ");
    while (token != NULL && i < 255) {
      args[i] = token;
      token = strtok(NULL, " ");
      i++;
    }
    args[i] = NULL; // execvp requires a NULL-terminated array

    // Execute the command using execvp
    printf("----->%s<-----", args[0]);
    execvp(args[0], args);

    // If execvp fails, the following code will be executed
    perror("execvp");
    exit(1);
  } else { // Parent process
    // Optionally wait a short time for the process to start
    sleep(1);
    return (int)pid;
  }
}
