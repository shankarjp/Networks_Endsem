
set ns [new Simulator]


#DV -> For RIP Routing Protocol
$ns rtproto DV

#LV -> For Link State Routing Protocol
#$ns rtproto LS


$ns color 1 Orange

set nf [open out.nam w]
$ns namtrace-all $nf
set nftr [open all.tr w]
$ns trace-all $nftr


set rows 5
set cols 5
set var [expr $rows*$cols]
proc finish {} {
	global ns nf nftr src dest
	$ns flush-trace
	close $nf
	exec nam out.nam & 
	exec awk -f /home/iii106120018/NW106120018/Lab8/pdr.awk all.tr > pdr_out_dvr &
	exec awk -f /home/iii106120018/NW106120018/Lab8/plr.awk all.tr > plr_out_dvr &
	exec awk -f /home/iii106120018/NW106120018/Lab8/overhead.awk all.tr > overhead_out_dvr &
	exec awk -f /home/iii106120018/NW106120018/Lab8/energyC.awk all.tr > energyC_out_dvr &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n3 10Mb 10ms DropTail
$ns duplex-link $n0 $n4 10Mb 10ms DropTail
$ns duplex-link $n0 $n5 10Mb 10ms DropTail
$ns duplex-link $n0 $n6 10Mb 10ms DropTail
$ns duplex-link $n0 $n7 10Mb 10ms DropTail
$ns duplex-link $n0 $n8 10Mb 10ms DropTail
$ns duplex-link $n0 $n9 10Mb 10ms DropTail

$ns color 2 blue

#===================================
#        Agents Definition        
#===================================

#Connection between 1 and 0

set tcp1 [ new Agent/TCP ]
$tcp1 set class_ 2
$ns attach-agent $n1 $tcp1
set sink [ new Agent/TCPSink]
$ns attach-agent $n0 $sink
$ns connect $tcp1 $sink

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP
$ftp1 set packet_size_ 1000
$ftp1 set rate_ 10mb

#Connection between 2 and 0

set tcp2 [ new Agent/TCP ]
$tcp2 set class_ 2
$ns attach-agent $n2 $tcp2
set sink [ new Agent/TCPSink]
$ns attach-agent $n0 $sink
$ns connect $tcp2 $sink

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP
$ftp2 set packet_size_ 1000
$ftp2 set rate_ 10mb

#Connection between 3 and 0

set tcp3 [ new Agent/TCP ]
$tcp3 set class_ 2
$ns attach-agent $n3 $tcp3
set sink [ new Agent/TCPSink]
$ns attach-agent $n0 $sink
$ns connect $tcp3 $sink

set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ftp3 set type_ FTP
$ftp3 set packet_size_ 1000
$ftp3 set rate_ 10mb

#Connection between 4 and 0

set tcp4 [ new Agent/TCP ]
$tcp4 set class_ 2
$ns attach-agent $n4 $tcp4
set sink [ new Agent/TCPSink]
$ns attach-agent $n0 $sink
$ns connect $tcp4 $sink

set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ftp4 set type_ FTP
$ftp4 set packet_size_ 1000
$ftp4 set rate_ 10mb

$ns at 1.0 "$ftp1 start"
$ns at 40.0 "$ftp1 stop"

$ns at 1.0 "$ftp2 start"
$ns at 60.0 "$ftp2 stop"

$ns at 1.0 "$ftp3 start"
$ns at 80.0 "$ftp3 stop"

$ns at 1.0 "$ftp4 start"
$ns at 100.0 "$ftp4 stop"

$ns at 100.0 "finish"


$ns run
