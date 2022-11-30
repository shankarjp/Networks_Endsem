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
#include <vector>
#include <thread>

#define PORT 9905
using namespace std;

void reverse(char *exp){
	
	int len=strlen(exp);
	
	for(int i=0;i<len/2;i++){
		char temp=exp[i];
		exp[i]=exp[len-i-1];
		exp[len-i-1]=temp;
	}
}
/*
void handleClient(){
	while(1){
		char clientResponse[100];
		recieve(clientResponse);
		if(clientResponse[0]=='x')
			break;
		reverse(clientResponse);
		cout<<"Message sent to Client: "<<clientResponse<<endl;
		send(clientSocket,clientResponse,sizeof(clientResponse),0);
	}
}*/

int main(){
	int serverSocket,clientSocket,valread;
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
	
	vector<thread*> threads;
	int count=0;
	
	if((clientSocket=accept(serverSocket,(struct sockaddr*)&address,(socklen_t*)&addrlen))<0){
		cout<<"\nAccept1 Error";
		return -1;
	}
	
	/*while(count<5){
		if((clientSocket=accept(serverSocket,(struct sockaddr*)&address,(socklen_t*)&addrlen))<0){
		cout<<"\nAccept1 Error";
		return -1;
	}
		cout<<"Connected"<<endl;
		thread* newThread=new thread(handleClient,clientSocket));
		
		threads.push_back(newThread);
		count++;
	}
	
	for(auto& th:threads){
		th->join();
	}*/
	
	while(1){
		recv(clientSocket,&clientResponse,sizeof(clientResponse),0);
		cout<<"Message recieved from client: "<<clientResponse<<endl;
		if(clientResponse[0]=='x')
			break;
		reverse(clientResponse);
		cout<<"Message sent to Client: "<<clientResponse<<endl;
		send(clientSocket,clientResponse,sizeof(clientResponse),0);
	}
	
	close(serverSocket);
	close(clientSocket);
	return 0;
	
}
	
