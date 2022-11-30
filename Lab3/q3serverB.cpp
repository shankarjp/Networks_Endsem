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

#define PORT 4322
using namespace std;

struct chunk{
	int index;
	int data;
};

int main(){
	int serverSocket, clientSocket,valread;
	struct sockaddr_in address;
	int addrlen=sizeof(address);
	
	struct chunk data[10];
	int values[5]={8,4,3,2,1};
	for(int i=0;i<10;i++){
		data[i].index=i;
		data[i].data=3*i;
	}
	
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
	
	for(int i=0;i<5;i++){
		int j;
		recv(clientSocket,&j,sizeof(j),0);
		cout<<"Sending Chunk "<<j<<" to Client"<<endl;
		send(clientSocket,&data[j],sizeof(data[j]),0);	
	}
	
	char message[100];
	recv(clientSocket,&message,sizeof(message),0);
	cout<<"Message from Client: "<<message;
	close(serverSocket);

	return 0;
	
}
