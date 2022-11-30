set ns [new Simulator]

#LS -> For OSPF Routing Protocol
#$ns rtproto LS

#DV -> For RIP Routing Protocol
$ns rtproto DV

$ns color 1 Orange

set nf [open out.nam w]
$ns namtrace-all $nf
set nftr [open all.tr w]
$ns trace-all $nftr


set rows [lindex $argv 0]
set cols [lindex $argv 1]
set src [lindex $argv 2]
set dest [lindex $argv 3]

proc finish {} {
	global ns nf nftr src dest
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exec awk -f /home/iii106120018/NW106120018/Lab7/pdr.awk all.tr > pdr_out &
	exec awk -f /home/iii106120018/NW106120018/Lab7/plr.awk all.tr > plr_out &
	exec awk -f /home/iii106120018/NW106120018/Lab7/overhead.awk all.tr > overhead_out &
	exec awk -f /home/iii106120018/NW106120018/Lab7/energyC.awk all.tr > energyC_out &
	exit 0
}

for {set i 0} {$i < ($rows * $cols)} {incr i} {
	set n($i) [$ns node]
}
for {set j 0} {$j < $rows-1} {incr j} {
	for {set i 0} {$i < $cols-1} {incr i} {
		$ns duplex-link $n([expr ($cols*($j)+$i)]) $n([expr ($cols*($j)+$i+1)]) 1Mb 10ms DropTail
	}
	for {set i 0} {$i < $cols} {incr i} {
		$ns duplex-link $n([expr ($cols*($j)+$i)]) $n([expr ($cols*($j+1)+$i)]) 1Mb 10ms DropTail
	}
}
for {set i 0} {$i < $cols-1} {incr i} {
	$ns duplex-link $n([expr ($rows-1)*($cols)+$i]) $n([expr ($rows-1)*($cols)+$i+1]) 1Mb 10ms DropTail
}


#TCP
set tcp [new Agent/TCP]
$tcp set fid_ 1
set sink [new Agent/TCPSink]

$ns attach-agent $n($src) $tcp
$ns attach-agent $n($dest) $sink

$ns connect $tcp $sink

#FTP over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#Scheduling event flow:-

$ns at 1.0 "$ftp start"


#For 50 stations:-
if {($rows * $cols)== 50} {
	puts "50 stations"
	$ns rtmodel-at 30 down $n(4) $n(5)

	$ns rtmodel-at 60 up $n(4) $n(5)
	
}

$ns at 99.5 "$ftp stop"

$ns at 100.0 "finish"


$ns run
