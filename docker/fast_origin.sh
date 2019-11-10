#!/bin/bash

cat > /etc/docker/daemon.json <<EOP
{
"registry-mirrors": ["https://mj9kvemk.mirror.aliyuncs.com"]
}
EOP
