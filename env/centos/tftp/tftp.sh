#!/bin/bash

yum install -y tftp-server tftp


cat /etc/xinetd.d/tftp <<EOP
service tftp
{
	socket_type = dgram
	protocol    = udp
	wait    = yes
	user    = root
	server  = /usr/sbin/in.tftpd
	server_args = -s /var/lib/tftpboot
	disable = no #此处将yes该为no
	per_source  = 11
	cps = 100 2
	flags   = IPv4
}
EOP

