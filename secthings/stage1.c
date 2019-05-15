#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
	printf("Executing stage 2\n");
	if (execve("./x2st", NULL, NULL) == -1)
		perror("Could not execve");
	return 1;
}
