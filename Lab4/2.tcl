set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set nr [open tfile.tr w]
$ns trace-all $nr

proc finish {} {
    global ns nf
    $ns flush-trace
    #Close the NAM trace file
    close $nf
    #Execute NAM on the trace file
    exec nam out.nam &
    exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n4 10Mb 10ms DropTail
$ns duplex-link $n4 $n0 10Mb 10ms DropTail

$ns color 2 blue

#Connection between 0 and 4

set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
$ns attach-agent $n0 $tcp0
set sink4 [new Agent/TCPSink]
$ns attach-agent $n4 $sink4
$ns connect $tcp0 $sink4

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp0
$cbr0 set type_ CBR

#Connection between 4 and 3

set tcp4 [new Agent/TCP]
$tcp4 set class_ 2
$ns attach-agent $n4 $tcp4
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp4 $sink3

set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $tcp4
$cbr4 set type_ CBR

#Connection between 3 and 2

set tcp3 [new Agent/TCP]
$tcp3 set class_ 2
$ns attach-agent $n3 $tcp3
set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2
$ns connect $tcp3 $sink2

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $tcp3
$cbr3 set type_ CBR

#Connection between 2 and 1

set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n2 $tcp2
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp2 $sink1

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $tcp2
$cbr2 set type_ CBR

#Connection between 1 and 0

set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n1 $tcp1
set sink0 [new Agent/TCPSink]
$ns attach-agent $n0 $sink0
$ns connect $tcp1 $sink0

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $tcp1
$cbr1 set type_ CBR

$ns at 1.0 "$cbr0 start"
$ns at 150.0 "$cbr0 stop"

$ns at 1.0 "$cbr1 start"
$ns at 150.0 "$cbr1 stop"

$ns at 1.0 "$cbr2 start"
$ns at 150.0 "$cbr2 stop"

$ns at 1.0 "$cbr3 start"
$ns at 150.0 "$cbr3 stop"

$ns at 1.0 "$cbr4 start"
$ns at 150.0 "$cbr4 stop"

$ns at 65.0 "finish"

$ns run

