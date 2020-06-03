#!/bin/bash

set -x
set -e

brname="br0"

if brctl show | grep -q $brname ; then
	echo "${brname} aleady exists"
	exit 0
else
	echo "start to add: ${brname}"

	sudo ip link add name ${brname} type bridge
	sudo ip link add name bond0.700 link bond0 type vlan id 700
	sudo ip link set bond0.700 up
	sudo ip link set dev bond0.700 master ${brname}
	sudo ip link set ${brname} up
	sudo systemctl restart network.service
	sudo bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

	echo "${brname} is added"
fi

