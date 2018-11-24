---
author: Florent
date: 2013-04-04 10:24:36+00:00
draft: false
title: Simulating bad network conditions on Linux
type: post
url: /blog/2013/simulating-bad-network-conditions-on-linux/
categories:
- UNIX
---

Sometimes, your network is just _too_ good.

Today I ran into this issue as I was testing an application running off a VM in the local network. Latency and bandwidth were excellent, as you'd expect, but nowhere near the conditions you'd encounter over the internet. Testing in these conditions is unrealistic and can lead to underestimating issues your users will experience with your app once it's deployed.

So let's change that and add artificial latency, bandwidth limitations, and even drop a few packets, using [tc](http://linux.die.net/man/8/tc).

Just put the following script in /etc/init.d, modify the values to fit your needs, make it executable, and run /etc/init.d/traffic_shaping.sh start to degrade performance accordingly.

```sh
#!/bin/bash
#
#  tc uses the following units when passed as a parameter.
#  kbps: Kilobytes per second 
#  mbps: Megabytes per second
#  kbit: Kilobits per second
#  mbit: Megabits per second
#  bps: Bytes per second 
#       Amounts of data can be specified in:
#       kb or k: Kilobytes
#       mb or m: Megabytes
#       mbit: Megabits
#       kbit: Kilobits
#  To get the byte figure from bits, divide the number by 8 bit
#

#
# Name of the traffic control command.
TC=/sbin/tc

# The network interface we're planning on limiting bandwidth.
IF=eth0              # Interface

# Latency
LAT_1=200ms          # Base latency
LAT_2=50ms           # Plus or minus
LAT_3=25%            # Based on previous packet %
# Dropping packets
DROP_1=5%            # Base probability
DROP_2=25%           # Based on previous packet %
# Bandwidth
DNLD=50kbps          # DOWNLOAD Limit
UPLD=50kbps          # UPLOAD Limit

# IP address of the machine we are controlling
IP=192.168.122.33     # Host IP

# Filter options for limiting the intended interface.
U32="$TC filter add dev $IF protocol ip parent 1:0 prio 1 u32"

start() {

# We'll use Hierarchical Token Bucket (HTB) to shape bandwidth.
# For detailed configuration options, please consult Linux man
# page.

    $TC qdisc add dev $IF root handle 2: netem delay $LAT_1 $LAT_2 $LAT_3 loss $DROP_1 $DROP_2
    $TC qdisc add dev $IF parent 2: handle 1: htb default 30
    $TC class add dev $IF parent 1: classid 1:1 htb rate $DNLD
    $TC class add dev $IF parent 1: classid 1:2 htb rate $UPLD
    $U32 match ip dst $IP/32 flowid 1:1
    $U32 match ip src $IP/32 flowid 1:2

# The first line creates the root qdisc, and the next three lines
# create three child qdisc that are to be used to shape download 
# and upload bandwidth.
#
# The 5th and 6th line creates the filter to match the interface.
# The 'dst' IP address is used to limit download speed, and the 
# 'src' IP address is used to limit upload speed.

}

stop() {

# Stop the bandwidth shaping.
    $TC qdisc del dev $IF root

}

restart() {

# Self-explanatory.
    stop
    sleep 1
    start

}

show() {

# Display status of traffic control status.
    $TC -s qdisc ls dev $IF

}

case "$1" in

  start)

    echo -n "Starting bandwidth shaping: "
    start
    echo "done"
    ;;

  stop)

    echo -n "Stopping bandwidth shaping: "
    stop
    echo "done"
    ;;

  restart)

    echo -n "Restarting bandwidth shaping: "
    restart
    echo "done"
    ;;

  show)

    echo "Bandwidth shaping status for $IF:"
    show
    echo ""
    ;;

  *)

    pwd=$(pwd)
    echo "Usage: tc.bash {start|stop|restart|show}"
    ;;

esac

exit 0
```

I originally found the script on [top web hosts' website](http://www.iplocation.net/tools/traffic-control.php), and added a few things. Props!
