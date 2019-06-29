#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
	FILE *fd;
	char buf[8092] = {'A'};
	fd = fopen("test.py",O_CREAT | 0777);
	fwrite(fd, buf, sizeof(buf), 0);
	fclose(fd);
	return 0;
}
	
	
