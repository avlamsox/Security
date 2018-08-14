
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/auxv.h>

int main(int argc, char *argv[]) {
  char *ptr;
  int i;

  for (i = 0; i < argc; i++) {
    printf("  argv[%d]: %p, %p, %s\n", i, argv + i, argv[i], argv[i]);
  }

  char * program = (char *)getauxval(AT_EXECFN);
  printf("AT_EXECFN:               , %p, %s\n", program, program);
  char* path = getenv("PATH");
  printf("     PATH:               , %p, %s\n", path, path);
  char* underscore = getenv("_");
  printf("        _:               , %p, %s\n", underscore, underscore);
}
