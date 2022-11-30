#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 10                         ;# max packet in ifq
set val(nn)     5                         ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      1290                      ;# X dimension of topography
set val(y)      531                      ;# Y dimension of topography
set val(stop)   10.0                         ;# time of simulation end
set val(xgap)      200
set val(ygap)      400
#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god ($val(nn)*$val(nn))

#Open the NS trace file
set tracefile [open all.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -energyModel   "EnergyModel" \
                -initialEnergy 50.0 \
                -txPower 0.9 \
                -rxPower 0.7 \
                -idlePower 0.6 \
                -sleepPower 0.1 \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 32 nodes

for {set i 0} {$i < ($val(nn)*$val(nn))} {incr i} {
    set n($i) [$ns node]
}


for {set i 0} {$i < $val(nn)} {incr i} {
    for {set j 0} {$j < $val(nn)} {incr j} {
        set index [expr ($i*$val(nn))+$j]
        $n($index) set X_ [expr int(($i+1)*$val(xgap))]
        $n($index) set Y_ [expr int(($j+1)*$val(ygap))]
        $n($index) set Z_ 0.0
        $ns initial_node_pos $n($index) 20
    }
}

$ns at 2.0 " $n(14) setdest 500 60 20 " 

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0
set sink2 [new Agent/TCPSink]
$ns attach-agent $n(5) $sink2
$ns connect $tcp0 $sink2
$tcp0 set packetSize_ 1500

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n(23) $tcp1
set sink3 [new Agent/TCPSink]
$ns attach-agent $n(24) $sink3
$ns connect $tcp1 $sink3
$tcp1 set packetSize_ 1500


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 2.0 "$ftp0 start"
$ns at 9.0 "$ftp0 stop"

#Setup a FTP Application over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 4.0 "$ftp1 start"
$ns at 9.0 "$ftp1 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam & 
    exec awk -f /home/iii106120018/NW106120018/Lab8/pdr.awk all.tr > aodv_pdr &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n($i) reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
