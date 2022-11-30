set ns [new Simulator]

#LV -> For Link State Routing Protocol
$ns rtproto LS


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
	exec awk -f /home/subasri/Acads/Computer_Networks_Lab/lab8/pdr.awk all.tr > /home/subasri/Acads/Computer_Networks_Lab/lab8/Grid/outfiles/pdr_out_lsr &
	exec awk -f /home/subasri/Acads/Computer_Networks_Lab/lab8/plr.awk all.tr > /home/subasri/Acads/Computer_Networks_Lab/lab8/Grid/outfiles/plr_out_lsr &
	exec awk -f /home/subasri/Acads/Computer_Networks_Lab/lab8/overhead.awk all.tr > /home/subasri/Acads/Computer_Networks_Lab/lab8/Grid/outfiles/overhead_out_lsr &
	exec awk -f /home/subasri/Acads/Computer_Networks_Lab/lab8/energyC.awk all.tr > /home/subasri/Acads/Computer_Networks_Lab/lab8/Grid/outfiles/energyC_out_lsr &
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

for {set i 0} {$i < 5} {incr i} {
    
	set tcp($i) [new Agent/TCP]
	$ns attach-agent $n([expr ($i)]) $tcp($i)
	set sink($i) [new Agent/TCPSink]
	$ns attach-agent $n([expr ($i) + 5]) $sink($i)
	$ns connect $tcp($i) $sink($i)
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $tcp($i)
	$ftp($i) set packetSize_ 500
	$ftp($i) set interval_ 0.005
    
}

for {set i 10} {$i < 15} {incr i} {
    
	set tcp($i) [new Agent/TCP]
	$ns attach-agent $n([expr ($i)]) $tcp($i)
	set sink($i) [new Agent/TCPSink]
	$ns attach-agent $n([expr ($i) + 5]) $sink($i)
	$ns connect $tcp($i) $sink($i)
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $tcp($i)
	$ftp($i) set packetSize_ 500
	$ftp($i) set interval_ 0.005
    
}
for {set i 20} {$i <= 22} {incr i 2} {
	set tcp($i) [new Agent/TCP]
	$ns attach-agent $n([expr ($i)]) $tcp($i)
	set sink($i) [new Agent/TCPSink]
	$ns attach-agent $n([expr ($i) + 1]) $sink($i)
	$ns connect $tcp($i) $sink($i)
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $tcp($i)
	$ftp($i) set packetSize_ 500
	$ftp($i) set interval_ 0.005
}
	set tcp(19) [new Agent/TCP]
	$ns attach-agent $n([expr (19)]) $tcp(19)
	set sink(19) [new Agent/TCPSink]
	$ns attach-agent $n([expr 24]) $sink(19)
	$ns connect $tcp(19) $sink(19)
	set ftp(19) [new Application/FTP]
	$ftp(19) attach-agent $tcp(19)
	$ftp(19) set packetSize_ 500
	$ftp(19) set interval_ 0.005

#Scheduling event flow:-

for {set i 0} {$i < 5} {incr i} {
	$ns  at 0.5 "$ftp($i) start"
    $ns at 100.0 "$ftp($i) stop"
}
for {set i 10} {$i < 15} {incr i} {
	$ns  at 0.5 "$ftp($i) start"
    $ns at 100.0 "$ftp($i) stop"
}

for {set i 20} {$i <= 22} {incr i 2} {
	$ns  at 0.5 "$ftp($i) start"
    $ns at 100.0 "$ftp($i) stop"
}

$ns  at 0.5 "$ftp(19) start"
    $ns at 100.0 "$ftp(19) stop"
	

$ns at 100.5 "finish"


$ns run