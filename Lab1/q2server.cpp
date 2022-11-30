#include <netinet/in.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>

#define PORT 1500
using namespace std;

int main(){
	int serverSocket, clientSocket,clientSocket2,valread;
	struct sockaddr_in address;
	int addrlen=sizeof(address);
	
	char serverMessage[100];
	char clientResponse[100];
	
	char Message2[100]={};
	char Message3[100]={};
	
	if((serverSocket=socket(AF_INET,SOCK_STREAM,0))<0){
		cout<<"\nSocket Creation Error";
		return -1;
	}
	
	address.sin_family=AF_INET;
	address.sin_port=htons(PORT);
	address.sin_addr.s_addr=INADDR_ANY;
	
	if(bind(serverSocket,(struct sockaddr*)&address,sizeof(address))<0){
		cout<<"Bind Failed"<<endl;
		return -1;
	}
	
	if(listen(serverSocket,5)<0){
		cout<<"Listen Error"<<endl;
		return -1;
	}
	
	if((clientSocket=accept(serverSocket,(struct sockaddr*)&address,(socklen_t*)&addrlen))<0){
		cout<<"\nAccept1 Error";
		return -1;
	}
	
	if((clientSocket2=accept(serverSocket,(struct sockaddr*)&address,(socklen_t*)&addrlen))<0){
		cout<<"\nAccept2 Error";
		return -1;
	}
	
	recv(clientSocket,&clientResponse,sizeof(clientResponse),0);
	cout<<"Message recieved from Client: "<<clientResponse<<endl;
	strncpy(Message2,clientResponse,strlen(clientResponse));
	
	for(int i=0;i<strlen(clientResponse);i++){
		Message2[i]=clientResponse[i]+1;
	}
	
	send(clientSocket,&Message2,sizeof(Message2),0);
	send(clientSocket2,&Message2,sizeof(Message2),0);
	
	strncpy(Message3,Message2,strlen(Message2));
	for(int i=0;i<strlen(clientResponse);i++){
		Message3[i]=Message2[i]+1;
	}
	
	recv(clientSocket2,&Message3,sizeof(Message3),0);
	send(clientSocket,&Message3,sizeof(Message3),0);
	
	cout<<Message3<<endl;
	
	close(serverSocket);
	return 0;
}
