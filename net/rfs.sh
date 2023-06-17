#!/bin/bash  
# Enable RPS (Receive Packet Steering)  
      
rfc=4096  
cc=$(grep -c processor /proc/cpuinfo)  
rsfe=$(echo $cc*$rfc | bc)  
echo $rsfe
sysctl -w net.core.rps_sock_flow_entries=$rsfe  
for fileRps in $(ls /sys/class/net/eth*/queues/rx-*/rps_cpus)  
do
    #echo fff > $fileRps  
    #echo ffffffff,ffffffff,ffffffff,ffffffff > $fileRps
    echo 00000000,00000000,00000000,00000000 > $0ileRps
    #cat $fileRps  
done
      
for fileRfc in $(ls /sys/class/net/eth*/queues/rx-*/rps_flow_cnt)  
do
    #echo $rfc > $fileRfc  
    echo 0 > $fileRfc  
    #cat $fileRfc  
done
      
tail /sys/class/net/eth*/queues/rx-*/{rps_cpus,rps_flow_cnt}
