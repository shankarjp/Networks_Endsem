
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
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n4 10Mb 10ms DropTail
$ns duplex-link $n4 $n5 10Mb 10ms DropTail
$ns duplex-link $n5 $n6 10Mb 10ms DropTail
$ns duplex-link $n6 $n7 10Mb 10ms DropTail
$ns duplex-link $n7 $n8 10Mb 10ms DropTail
$ns duplex-link $n8 $n9 10Mb 10ms DropTail

$ns color 2 blue

#===================================
#        Agents Definition        
#===================================

#Connection between 0 and 4

set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
$ns attach-agent $n2 $tcp0
set sink4 [new Agent/TCPSink]
$ns attach-agent $n9 $sink4
$ns connect $tcp0 $sink4

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

#Connection between 4 and 3

set tcp4 [new Agent/TCP]
$tcp4 set class_ 2
$ns attach-agent $n0 $tcp4
set sink3 [new Agent/TCPSink]
$ns attach-agent $n7 $sink3
$ns connect $tcp4 $sink3

set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ftp4 set type_ FTP

$ns at 1.0 "$ftp0 start"
$ns at 60.0 "$ftp0 stop"

$ns at 1.0 "$ftp4 start"
$ns at 60.0 "$ftp4 stop"

$ns at 100.5 "finish"


$ns run
