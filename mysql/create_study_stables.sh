#!/bin/bash

#create_table_sql="create table IF NOT EXISTS khotfix_debug (akid varchar(100), id int(10) UNSIGNED AUTO_INCREMENT, link varchar(1024) , summary varchar(200), description varchar(2048), author varchar(64), functest varchar(4096), patchlink varchar(1024), aone_link varchar(2048), PRIMARY KEY ("id"))"
create_table_sql="create table IF NOT EXISTS study (id int(10) UNSIGNED AUTO_INCREMENT,name varchar(20), gae int(11), sex varchar(20), city varchar(20), PRIMARY KEY ("id"))"
mysql -u root -p -D hiber_test -e "${create_table_sql}"
