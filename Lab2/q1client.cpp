#include <arpa/inet.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 9902
using namespace std;

int main(){
	int sock=0, valread;
	struct sockaddr_in serv_addr;
	
	char word[100];
	char buffer[1024]={0};
	
	if((sock=socket(AF_INET,SOCK_STREAM,0))<0){
		cout<<"\nSocket Creation Error";
		return -1;
	}
	
	memset(&serv_addr,'0',sizeof(serv_addr));
	
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons(PORT);
	serv_addr.sin_addr.s_addr=INADDR_ANY;
	
	if(connect(sock,(struct sockaddr*)&serv_addr,sizeof(serv_addr))<0){
		cout<<"\nConnection Failed";
		return -1;
	}
	
	while(1){
		cout<<"\nEnter expression: ";
		int n=0;
		fgets(word,100,stdin);
		if(word[0]=='x')
			break;
		send(sock,word,sizeof(word),0);
		recv(sock,buffer,sizeof(buffer),0);
		cout<<"Message from Server: "<<buffer;
	}
	
	close(sock);
	
	return 0;
}
