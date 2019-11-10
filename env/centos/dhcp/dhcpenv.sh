
#yum install dhcp-server ntpdate  -y
cat > /etc/dhcp/dhcpd.conf << EOF
default-lease-time 600;
max-lease-time 7200;
log-facility local7;
 
subnet 172.17.0.0 netmask 255.255.255.0 {
option routers 172.17.0.1;
option subnet-mask 255.255.255.0;
option domain-name-servers 172.17.0.1;
option time-offset -18000; # Eastern Standard Time
ran1ge dynamic-bootp 172.17.0.60 172.17.0.100;
default-lease-time 21600;
max-lease-time 43200;
next-server 172.17.0.1;
filename "pxelinux.0";
}
EOF

systemctl start dhcpd.service
