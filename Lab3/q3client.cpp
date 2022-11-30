#include <arpa/inet.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT1 4321
#define PORT2 4322
using namespace std;

struct chunk{
	int index;
	int data;
};

int main(){
	int sock1=0, sock2=0, valread;
	struct sockaddr_in serv_addr;
	
	chunk data[10],sample;
	int isgot[10];
	memset(isgot,0,sizeof(isgot));
		
	if((sock1=socket(AF_INET,SOCK_STREAM,0))<0){
		cout<<"\nSocket Creation Error";
		return -1;
	}
	
	memset(&serv_addr,'0',sizeof(serv_addr));
	
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons(PORT1);
	serv_addr.sin_addr.s_addr=INADDR_ANY;
	
	if(connect(sock1,(struct sockaddr*)&serv_addr,sizeof(serv_addr))<0){
		cout<<"\nConnection Failed";
		return -1;
	}
	
	for(int i=0;i<5;i++){
		recv(sock1,&sample,sizeof(sample),0);
		cout<<"Chunk "<<sample.index<<" has been recieved: "<<sample.data<<endl;
		isgot[sample.index]=1;
		data[sample.index]=sample;
	}
	
	if((sock2=socket(AF_INET,SOCK_STREAM,0))<0){
		cout<<"\nSocket Creation Error";
		return -1;
	}
	
	memset(&serv_addr,'0',sizeof(serv_addr));
	
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons(PORT2);
	serv_addr.sin_addr.s_addr=INADDR_ANY;
	
	if(connect(sock2,(struct sockaddr*)&serv_addr,sizeof(serv_addr))<0){
		cout<<"\nConnection Failed";
		return -1;
	}
	
	for(int i=0;i<10;i++){
		if(isgot[i]==0){
			send(sock2,&i,sizeof(i),0);
			recv(sock2,&sample,sizeof(sample),0);
			cout<<"Chunk "<<sample.index<<" has been recieved: "<<sample.data<<endl;
			data[i]=sample;		
		}
	}
	
	char endmessage[10]="Thanks";
	send(sock1,&endmessage,sizeof(endmessage),0);
	send(sock2,&endmessage,sizeof(endmessage),0);
	close(sock1);
	close(sock2);
	
	return 0;
}
