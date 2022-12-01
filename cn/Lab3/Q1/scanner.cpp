#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <ctype.h>
using  namespace std; 


int main(int argc, char *argv[]) 
{
    if(argc < 2) {
        fprintf(stderr, "Usage: %s Hostname Port\n", argv[0]);
        exit(0);
    }  
    
    
    for(int i=1; i<=1026; i++)
    {
        int sockfd;
        struct sockaddr_in serv_addr;
        struct hostent *server; 
        
        server = gethostbyname(argv[1]);
        
        
        if(server == NULL) {
           fprintf(stderr, "Error, No Such Host.\n");
           exit(1);
        }
        
        sockfd = socket(AF_INET, SOCK_STREAM, 0);
    
        if(sockfd < 0) {
           fprintf(stderr, "Error Opening Socket.");
           exit(1);
        }
         
    
        bzero((char *) &serv_addr, sizeof(serv_addr));
        serv_addr.sin_family = AF_INET;
        bcopy((char *) server->h_addr, (char *) &serv_addr.sin_addr.s_addr, server->h_length);
        
        int portno = i;
        
        serv_addr.sin_port = htons(portno);
        
        int status = connect(sockfd, (struct sockaddr*) &serv_addr, sizeof(serv_addr));

        if(status == -1)
        fprintf(stdout, "Port %d is free.\n", portno);
        else
        fprintf(stdout, "Port %d is busy.\n", portno);
    
        close(sockfd);
    }
        
    return 0;
}










