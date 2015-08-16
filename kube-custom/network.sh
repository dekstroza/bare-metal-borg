#!/bin/bash

#Assuming HOST1 is first node, and HOST2 is second node in overlay network

#IP of first host, over which it can be reached from HOST2
HOST1_IP=/*Enter HOST1 IP address*/
#Netmask for HOST1 ip
HOST1_NETMASK=/*Enter net mask here, usually 24*/
#Device with above IP
HOST1_NETWORK_DEVICE='eth0'

#Second host with IP, over which it can be reached from HOST1
HOST2_IP=/*Enter HOST2 IP address, over which HOST1 can reach it*/

#Overlay network CIDR 
OVERLAY_CIDR='10.244.0.0/16'

#IP address we wish HOST1 to have in our overlay network
HOST1_CBR_IP='10.244.1.1/24'

#MTU for overlay network, very important!!!
OVS_MTU=1446
#Default MTU
DEFAULT_MTU=1500

#Start off by creating two bridges

brctl addbr cbr0
ifconfig cbr0 $HOST1_CBR_IP  mtu $OVS_MTU up
ovs-vsctl add-br br0
ovs-vsctl add-br br1

#Create ovs-bridge ports
ovs-vsctl add-port br1 $HOST1_NETWORK_DEVICE
ovs-vsctl add-port br1 vx0 -- set interface vx0 type=vxlan  options:remote_ip=$HOST2_IP
#move host1 network device ip to bridge br0
ifconfig $HOST1_NETWORK_DEVICE 0 && ifconfig br0 $HOST1_IP/$HOST1_NETMASK mtu $DEFAULT_MTU up
ifconfig br0 mtu $DEFAULT_MTU up
ifconfig br1 mtu $OVS_MTU up
#Add br as interface to cbr0
brctl addif cbr0 br1

#Add route for overlay network
route add -net $OVERLAY_CIDR dev cbr0

#Mask all traffic over 'real network'
iptables -w -t nat -A POSTROUTING -o br0 -j MASQUERADE \! -d 10.244.0.0/16

#Firewall disabled, and connectivity should be now fully set, once the other end (HOST2) is configured, using same as above with correct values for IP addresses
#Docker should be running with -b cbr0 --mtu $OVS_MTU

 
