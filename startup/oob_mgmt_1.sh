#!/bin/bash
## mgmt namespace
#
# vars
IFACE='eno1' # management interface
IP='10.11.253.231' # management IP
MASK='24' # CIDR mask, e.g. /24
GATEWAY='10.11.253.1' # default gateway
DNS1='10.11.6.11' # primary DNS
DNS2='10.11.6.12' # secondary DNS
#
# config
ip netns add mgmt && echo "Added mgmt namespace" 1> /opt/scripts/startup.log
ip link set $IFACE netns mgmt && echo "Moved $IFACE to mgmt namespace" 1> /opt/scripts/startup.log
ip netns exec mgmt ip link set $IFACE up && echo "Brought up $IFACE in mgmt namespace" 1> /opt/scripts/startup.log
ip netns exec mgmt ip addr add "$IP/$MASK" dev $IFACE && echo "Added IP $IP/$MASK to $IFACE in mgmt netspace" 1> /opt/scripts/startup.log
ip netns exec mgmt ip route add default via $GATEWAY && echo "Added Default Gateway $GATEWAY in mgmt namespace" 1> /opt/scripts/startup.log
printf "# mgmt namespace nameservers from /opt/scripts/oob_mgmt_1.sh\nnameserver $DNS1\nnameserver $DNS2\n" > /etc/netns/mgmt/resolv.conf
echo "Added nameservers to /etc/netns/mgmt/resolv.conf" 2> /opt/scripts/startup.log
#
