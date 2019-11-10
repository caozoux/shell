#!/bin/bash

qemu-img create -f qcow2 test.qcow2 10G

#  qemu-nbd -c /dev/nbd0 rhel6u3.qcow2
