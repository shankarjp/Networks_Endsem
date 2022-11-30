#include <arpa/inet.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

using namespace std;

int main(){
	int sock=0, valread, clientSocket;
	struct sockaddr_in serv_addr;
	
	int start,end;
	cout<<"Enter starting and ending port: "<<endl;
	cin>>start>>end;
	
	for(int i=start;i<=end;i++){
		if((sock=socket(AF_INET,SOCK_STREAM,0))<0){
			cout<<"\nSocket Creation Error";
			return -1;
	}
	
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons(i);
	serv_addr.sin_addr.s_addr=INADDR_ANY;
	
	if((clientSocket=connect(sock,(struct sockaddr*)&serv_addr,sizeof(serv_addr)))<0){
		cout<<"\nPORT "<<i<<" : CLOSED";
	}else{
		cout<<"\nPORT "<<i<<" : OPEN";
	}
	
	close(sock);
	}
	
	return 0;
}
