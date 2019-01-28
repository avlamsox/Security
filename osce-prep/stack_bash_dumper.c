#include <stdio.h>
#include <stdlib.h>
#include "help.h"

extern char **environ;

unsigned long find_start() {
	__asm__("movl %esp, %eax");
}
unsigned long  stack_address, environment_address, bash_address;

int get_stack_values(struct stack_st *program_values) {
	
	program_values->stack_address = (unsigned long)find_start;
	int i = 0;
	char cmp_buf[10];
	
	program_values->environment_address = (unsigned long)*((char **)environ);
	printf("/*-----------------Library Function Started--------------------*/\n");
	printf("Stack for This program is @ [%p]\n",program_values->stack_address);
	for (i = 0; i < 100; i++) {
		snprintf(cmp_buf, sizeof(cmp_buf),"%s\n",program_values->environment_address++);
		if (strncmp(cmp_buf, "/bin/bash", strlen("/bin/bash") + 1) == 0) {
			printf("/bin/bash located at %p address on the stack\n", program_values->environment_address);
			program_values->bash_address = program_values->environment_address;
			printf("/#######################Library Function Started#######################/\n");
			return 0;
		}
				
	}
	return 0;
}
