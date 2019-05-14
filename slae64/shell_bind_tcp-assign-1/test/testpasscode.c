
#include <stdio.h>

char *passcode = "opensessame";

int main(int argc, char *argv[]) {
	if (argc < 2) {
		printf("Usage: <exec> <passcode>\n");
		exit(1);
	} else {
		if (argv[1]) {
			if(strncmp(argv[1], passcode, strlen(passcode)) == 0) {
				printf("Passcode valid - Exec shell code\n");
			} else
				printf("Invalid Passcode !!\n");
		}
	}
		
	return 0;
}
