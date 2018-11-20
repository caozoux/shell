#!/bin/bash

akid="D656712"
kernel="ali2016"
rpmname="kernel-hotfix-D656712-ali2016-1.0-1.alios7.x86_64.rpm"
downlink="http://yum.tbsite.net/taobao/7/x86_64/current/kernel-hotfix-D656712-ali2016/kernel-hotfix-D656712-ali2016-1.0-1.alios7.x86_64.rpm"

insert_table_sql="INSERT INTO rpmpackages_debug(`akid`,`kernel`,`rpmname`,`downlink`) SELECT '$alid','$kernel','$rpmname','$downlink' FROM DUAL WHERE NOT EXISTS(SELECT downlink FROM rpmpackages_debug WHERE downlink='$downlink');"
echo $insert_table_sql
#create_table_sql="create table IF NOT EXISTS khotfix_debug (id int(10) UNSIGNED AUTO_INCREMENT,akid varchar(100), PRIMARY KEY ("id"))"
mysql -u root -p123456 -D khotfix_test  -e "${create_table_sql}"
