set ns [new Simulator]

#tcp
$ns color 1 Green    
#udp
$ns color 2 Orange   

#Log simulation info to run awk scripts on
set tracefile [open q1log.tr w]
$ns trace-all $tracefile

#Nam Trace FILE for the animation
set nf [open q1disp.nam w]
$ns namtrace-all $nf

#finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exit 0
}

#Node Creation
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#Links
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

#TCP
set tcp [new Agent/TCP]
$tcp set fid_ 1
set sink [new Agent/TCPSink]

$ns attach-agent $n0 $tcp
$ns attach-agent $n3 $sink

$ns connect $tcp $sink

#FTP over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#UDP
set udp [new Agent/UDP]
$udp set fid_ 2
set null [new Agent/Null]

$ns attach-agent $n1 $udp
$ns attach-agent $n3 $null
$ns connect $udp $null

#CBR over UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 1000
$cbr set rate_ 1Mb


#Scheduling event flow:-
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"

$ns at 5.0 "finish"

puts " "
puts "---------------------------------------------------------------------------------------------- "
puts " The NAM and Log Trace files have been created. Do run the following commands in this order:- "
puts "---------------------------------------------------------------------------------------------- "
puts " 1. For viewing the simulation : nam q1disp.nam"
puts " 2. For calculating no of packets received and transmitted : awk -f pktflowdata.awk q1log.tr "
puts "---------------------------------------------------------------------------------------------- "
puts " "

#Run the simulation
$ns run


