#!/usr/bin/expect 
spawn ssh zoucao-ipc@192.168.0.101

expect {
      "assword:" {
        send "123456\n"
      }
 }

expect "ali*"
send "ls\n"
expect "ali*"
#interact
