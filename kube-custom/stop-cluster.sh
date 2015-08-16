#!/bin/bash
ps aux | grep kubelet | awk '{print $2}' | xargs kill -9 && ps aux | grep kube-proxy | awk '{print $2}' | xargs kill -9 && service docker restart && docker ps -a | grep Exited | awk '{print $1}' | xargs docker rm -v && iptables -t nat -F && iptables -w -t nat -A POSTROUTING -o br0 -j MASQUERADE \! -d 10.244.0.0/16
