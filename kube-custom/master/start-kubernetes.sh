#!/bin/bash

kubelet --hostname-override=10.244.1.1 --allow-privileged=true  --address=10.244.1.1 --enable-server=true  --api-servers=http://127.0.0.1:8080 --config=/etc/kubernetes/manifests --cluster-dns=10.0.0.10 --cluster-domain=enm.local --register-node=true --configure-cbr0=false > /var/log/kubelet.log 2>&1 &

kube-proxy --master=http://127.0.0.1:8080  > /var/log/kube-proxy.log 2>&1 &

