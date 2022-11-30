BEGIN{
stime=0
ftime=0
flag=0
fsize=0
throughput=0
latency=0
}

{
if ($1=="r")
{
	fsize+=$6
	if(flag==0)
	{ stime=$2
	flag=1
	}
	ftime=$2
}
}

END{
latency=ftime-stime
throughput=(fsize*8)/latency
printf("\n Throughput: %f Mega Bits per sec", throughput/1000000)
}
