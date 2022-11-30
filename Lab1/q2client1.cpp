#include <arpa/inet.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 1500
using namespace std;

int main(){
	int sock=0, valread, clientSocket;
	struct sockaddr_in serv_addr;
	
	if((sock=socket(AF_INET,SOCK_STREAM,0))<0){
		cout<<"\nSocket Creation Error";
		return -1;
	}
	
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons(PORT);
	serv_addr.sin_addr.s_addr=INADDR_ANY;
	
	if((clientSocket=connect(sock,(struct sockaddr*)&serv_addr,sizeof(serv_addr)))<0){
		cout<<"\nConnection Failed";
		return -1;
	}
	
	char serverResponse[100];
	char clientMessage[100];
	
	cout<<"Enter string: ";
	fgets(clientMessage,100,stdin);
	
	send(sock,&clientMessage,sizeof(clientMessage),0);
	recv(sock,&serverResponse,sizeof(serverResponse),0);
	cout<<serverResponse<<endl;
	
	char output[100];
	recv(sock,&output,sizeof(output),0);
	cout<<output<<endl;
	
	close(sock);
	return 0;
}
