BEGIN{
pktsend=0;
pktrecv=0;
}
{

e=$1;
dest=$4;
src=$3;

if(e =="+" && (src==0 || src==1))
{
pktsend++;
}

if(e =="r" && dest==3)
{
pktrecv++;
}

}

END{

printf("No of Packets sent by sources : %d \n" , pktsend);
printf("No of Packets received by destination : %d \n" , pktrecv);


}
