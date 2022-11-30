#include <arpa/inet.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 1500
using namespace std;

int main(){
	int sock2=0, valread, clientSocket;
	struct sockaddr_in serv_addr;
	
	if((sock2=socket(AF_INET,SOCK_STREAM,0))<0){
		cout<<"\nSocket Creation Error";
		return -1;
	}
	
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons(PORT);
	serv_addr.sin_addr.s_addr=INADDR_ANY;
	
	if((clientSocket=connect(sock2,(struct sockaddr*)&serv_addr,sizeof(serv_addr)))<0){
		cout<<"\nConnection Failed";
		return -1;
	}
	
	char serverResponse[100];
	char clientMessage[100];
	
	recv(sock2,&serverResponse,sizeof(serverResponse),0);
	cout<<"Message from Server: "<<serverResponse<<endl;
	
	char message2[100];
	strncpy(message2,serverResponse,strlen(serverResponse));
	for(int i=0;i<strlen(serverResponse);i++){
		message2[i]=serverResponse[i]+1;
	}
	
	cout<<"Message sent to server: "<<message2<<endl;
	send(sock2,&message2,sizeof(message2),0);
	
	close(sock2);
	return 0;
}
