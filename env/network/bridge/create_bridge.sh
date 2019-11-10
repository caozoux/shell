#!/bin/bash

# cat /etc/sysconfig/network-scripts/ifcfg-eth0 
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NAME="System eth0"
BRIDGE="br0"
# cat /etc/sysconfig/network-scripts/ifcfg-br0
DEVICE="br0"
TYPE="Bridge"  # 注意大小写
BOOTPROTO="static"
IPADDR=192.168.80.131
NETMASK=255.255.255.0
GATEWAY=192.168.80.2
ONBOOT="yes"
DELAY=0
