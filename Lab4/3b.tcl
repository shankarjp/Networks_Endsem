set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set nr [open tfile32.tr w]
$ns trace-all $nr

proc finish {} {
    global ns nf nr
    $ns flush-trace
    #Close the NAM trace file
    close $nf
    close $nr
    #Execute NAM on the trace file
    exec nam out.nam &
    exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n3 10Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient up
$ns duplex-link-op $n0 $n2 orient left
$ns duplex-link-op $n0 $n3 orient right

$ns color 2 red

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

$ns at 1.0 "$ftp1 start"
$ns at 60.0 "$ftp1 stop"

$ns at 1.0 "$ftp2 start"
$ns at 60.0 "$ftp2 stop"

$ns at 1.0 "$ftp3 start"
$ns at 60.0 "$ftp3 stop"

$ns at 65.0 "finish"

$ns run


#r for recieved, d for drop, + and - for enqueue and dequeue, second parameter is time in seconds, third one is the number of the 
#sender, and the fourth one is the reciever, fifth is the protocol, sixth is packet size, seventh is the flag, 
