#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 0 Blue
$ns color 1 Red
$ns color 3 green
$ns color 4 cyan
$ns color 5 yellow
$ns color 6 orange
$ns color 7 black
$ns color 8 purple
$ns color 9 gold
$ns color 10 maroon
$ns color 11 violet
$ns color 12 brown

#rpN = Routing Protocol Number

#Number0 Static Routing 
$ns rtproto Static
set rpN 0

#Number1 Session Routing 
#$ns rtproto Session
#set rpN 1

#Number2 Link State Routing
#$ns rtproto LS
#set rpN 2

#Number3 Distance Vector Routing
#$ns rtproto DV
#set rpN 3

#Number4 Algorithmic Routing Protocol
# $ns rtproto Algorithmic
# set rpN 4

#Open the nam trace file
set nf [open random$rpN.nam w]
$ns namtrace-all $nf

set all_trace [open random$rpN.tr w]
$ns trace-all $all_trace

set N 25
set nsrc 12

#Define a 'finish' procedure
proc finish {} {
    global rpN ns nf all_trace traffic
    $ns flush-trace
    #Close the trace file
    close $nf
    close $all_trace
    #Execute nam on the trace file
    exec nam random${rpN}.nam &
	exec awk -f pdr.awk random$rpN.tr > random${rpN}_pdr_out &
	exec awk -f overhead.awk random$rpN.tr > random${rpN}_overhead_out &
	exec awk -f plr.awk random$rpN.tr > random${rpN}_plr_out &
    exec awk -f energyC.awk random$rpN.tr > random${rpN}_energy_out &
	exit 0
}

for {set i 0} {$i < $N} {incr i} {
	set n($i) [$ns node]
}


#Random Linking. For each node, we find a random node to connect
for {set i 0} {$i < [expr $N-1]} {incr i} {

    #Two random nodes between i and N are generated. Then they are connected.
    set y $i
    set z $i
    while {$y <= $i} {
       set y [expr (int(rand()*$N))%$N]
    }
    while {$z <= $i} {
       set z [expr (int(rand()*$N))%$N]
    }
    $ns duplex-link $n($i) $n($y) 1Mb 10ms DropTail
    $ns duplex-link $n($i) $n($z) 1Mb 10ms DropTail
    $ns queue-limit $n($i) $n($y) 100
    $ns queue-limit $n($i) $n($z) 100
}

for {set i 0} {$i < $nsrc} {incr i} {
	#Setup a TCP connection
	set tcp($i) [new Agent/TCP]
	$tcp($i) set class_ 2
	$ns attach-agent $n($i) $tcp($i)

    #Connecting 0 with 24, 1 to 23...
	set sink($i) [new Agent/TCPSink]
	$ns attach-agent $n([expr $N-$i-1]) $sink($i)
	$ns connect $tcp($i) $sink($i)
	$tcp($i) set fid_ $i

	#Setup a FTP over TCP connection
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $tcp($i)
	$ftp($i) set type_ FTP
}

for {set i 0} {$i < $nsrc} {incr i} {
	$ns  at 0.0 "$ftp($i) start"
}

for {set i 0} {$i < $nsrc} {incr i} {
	$ns at 100.0 "$ftp($i) stop"
}

$ns at 100.0 "finish"

#Run the simulation
$ns run
