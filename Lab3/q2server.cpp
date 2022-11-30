#include <netinet/in.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <math.h>
#include <stack>
#include <ctype.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>

#define PORT 9902
using namespace std;

int main(){
	int serverSocket, clientSocket,valread;
	struct sockaddr_in address;
	int addrlen=sizeof(address);
	
	char serverMessage[100];
	char clientResponse[100];
	
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
	
	recv(clientSocket,&clientResponse,sizeof(clientResponse),0);
	cout<<"Client: "<<clientResponse<<endl;
	send(clientSocket,clientResponse,sizeof(clientResponse),0);
	cout<<"Server: "<<clientResponse<<endl;
	close(serverSocket);
	close(clientSocket);
	return 0;
	
}
	
