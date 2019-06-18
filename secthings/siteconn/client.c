   #include <stdio.h> 
    #include <stdlib.h> 
    #include <errno.h> 
    #include <string.h> 
    #include <netdb.h> 
    #include <sys/types.h> 
    #include <netinet/in.h> 
    #include <fcntl.h> 
    #include <sys/socket.h> 
    #include <unistd.h>
    #include <sys/socket.h>
    #include <arpa/inet.h>
	#include <errno.h>
    #define PORT 3490    /* the port client will be connecting to */
    #define MAXDATASIZE 8092 /* max number of bytes we can get at once */

    int main(int argc, char *argv[])
    {
        int sockfd, numbytes, read_return;  
        char buf[MAXDATASIZE];
	int ret, i;
	//int fp;
	FILE *fp;
        struct hostent *he;
        struct sockaddr_in their_addr; /* connector's address information */

        if (argc != 3) {
            fprintf(stderr,"usage: exec <port> <ip>\n");
            exit(1);
        }

        if ((he=gethostbyname(argv[1])) == NULL) {  /* get the host info */
            herror("gethostbyname");
            exit(1);
        }
	if ( inet_aton(argv[2], &their_addr.sin_addr.s_addr) == 0 )
	    {
        perror(argv[2]);
        exit(errno);
	    }


        if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
            perror("socket");
            exit(1);
        }

        their_addr.sin_family = AF_INET;      /* host byte order */
        their_addr.sin_port = htons(atoi(argv[1]));    /* short, network byte order */
 //       their_addr.sin_addr = *((struct in_addr *)he->h_addr);
        bzero(&(their_addr.sin_zero), 8);     /* zero the rest of the struct */

        if (connect(sockfd, (struct sockaddr *)&their_addr, \
                                              sizeof(struct sockaddr)) == -1) {
            perror("connect");
            exit(1);
        }
        
	printf("Buffer at %p \n",buf);

	//fp = open("stage2.bin",O_CREAT | O_APPEND);
	fp = fopen("stage2.bin","wb");

	while (1) {
		/*if (send(sockfd, "Hello, world!\n", 14, 0) == -1){
                      perror("send");
		      exit (1);
		}
		printf("After the send function \n");*/

        	if ((numbytes=recv(sockfd, buf, MAXDATASIZE, 0)) == -1) {
            		perror("recv");
            		exit(1);
		}	

	        buf[numbytes] = '\0';

        	//printf("Received in pid=%d, text=: %s \n",getpid(), buf);
		sleep(1);
		break;
		//write(fp, buf, numbytes);

	}

        printf("Received in pid=%d, text=: %s \n",getpid(), buf);
/*	ret = write(fp, &buf, numbytes);
	printf("wrote %d bytes as %d\n",ret ,numbytes);
	if (ret == -1) {
		printf("Error -1\n");
		strerror(errno);
	}*/
	
	printf("Buffer at %p \n",buf);
		
	for (i = 0; i < numbytes; i++) 
		fwrite(&buf, numbytes, 1, fp);
	
 //       printf("text=: %s \n",getpid(), buf);

        close(sockfd);
        fclose(fp);

        return 0;
    }



