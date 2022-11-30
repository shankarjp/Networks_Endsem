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

int evaluatePostfix(char *exp){
	stack<int> st;
	
	for(int i=0;exp[i];){
		if(isdigit(exp[i])){
			int num=0;
			while(isdigit(exp[i])){
				num=num*10+(exp[i]-'0');
				i++;
			}
			st.push(num);
		}
		if(isspace(exp[i])){
			i++;
			continue;	
		}else{
			int val1=st.top();
			st.pop();
			int val2=st.top();
			st.pop();
			switch(exp[i]){
				case '+':{
					st.push(val2+val1);
					break;
				}
				case '-':
				{
					st.push(val2-val1);
					break;
				}
				case '*':
				{
					st.push(val2*val1);
					break;
				}
				case '/':
				{
					st.push(val2/val1);
					break;
				}
			}
			i++;
		}
	}
	
	return st.top();
}

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
	
	while(1){
		recv(clientSocket,&clientResponse,sizeof(clientResponse),0);
		cout<<"Message recieved from client: "<<clientResponse<<endl;
		int result;
		if(clientResponse[0]=='x')
			break;
		result=evaluatePostfix(clientResponse);
		sprintf(serverMessage,"%d",result);
		cout<<"Message sent to Client: "<<serverMessage<<endl;
		send(clientSocket,serverMessage,sizeof(serverMessage),0);
	}
	
	close(serverSocket);
	close(clientSocket);
	return 0;
	
}
	
