BEGIN{

	stime=0
	ftime=0
	flag=0
	fsize=0
	latency=0
	throughput=0
	
}

{
	if($1=="r" && $4=="3")
	{
		fsize+=$6
		if(flag==0)
		{	stime=$2
			flag=1
		}
		ftime=$2
	}
}

END{
	latency=ftime-stime
	throughput = (fsize*8)/(latency*1000000)
	
	printf("\n throughput:%f",throughput)


}

		
