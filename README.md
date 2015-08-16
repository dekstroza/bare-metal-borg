# bare-metal-borg
Bare metal kubernetes setup with ovs vxlan

In order to run bare metal kubernetes, we need to set up overlay network. In this example, we have two hosts, HOST1 and HOST2, each host has eth0 interface with addresses: 

HOST1 has eth0 with: 159.107.152.3 

HOST2 has eht0 with: 159.107.152.161

Both hosts should be able to ping each other over those addresses. I am also assuming here eth0 on both hosts has default MTU 1500. MTU on overlay network needs to be reduced, as vxlan will encapsulate traffic, here we will be setting it to 1446, why this number, you may ask:

Inner ethernet frame 1518 

plus

Outer IPv4 Header 20 bytes

plus

Outer UDP Header 8 bytes 

plus

VXLAN Header(8 bytes) 

gives: 1554

MTU 1500 - 1554  = 54 bytes overhead, so we will reduce our default mtu by 54 bytes, 1500 - 54 = 1446


We are setting up overlay network 10.244.0.0/16 where in the overlay network:
HOST1 will have IP 10.244.1.1/24
HOST2 will have IP 10.244.2.1/24

Docker on both hosts will be using bridge cbr0 with these set: 

-b cbr0 --iptables=false --ip-masq=false --mtu=1446 

Kubernetes will run with dns enabled, and kubernetes binaries should be present on classpath.
Everything from manifests should be on master, in directory /etc/kubernetes/manifests , on minion(s) this directory should be empty.

It should be noted that using these, one can expand network with arbitraty number of minions.
