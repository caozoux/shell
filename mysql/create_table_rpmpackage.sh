#!/bin/bash

create_table_sql="create table IF NOT EXISTS rpmpackages_debug (id int(10) UNSIGNED AUTO_INCREMENT, akid varchar(100), kernel varchar(1024) , rpmname varchar(200), downlink varchar(2048), PRIMARY KEY ("id"))"
#create_table_sql="create table IF NOT EXISTS khotfix_debug (id int(10) UNSIGNED AUTO_INCREMENT,akid varchar(100), PRIMARY KEY ("id"))"
mysql -u root -p -D khotfix_test  -e "${create_table_sql}"
