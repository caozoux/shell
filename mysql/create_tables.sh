#!/bin/bash

create_table_sql="create table IF NOT EXISTS khotfix_debug (id int(10) UNSIGNED AUTO_INCREMENT, akid varchar(100), link varchar(1024) , summary varchar(200), description varchar(2048), author varchar(64), functest varchar(4096), patchlink varchar(1024), aonelink varchar(2048), PRIMARY KEY ("id"))"
#create_table_sql="create table IF NOT EXISTS khotfix_debug (id int(10) UNSIGNED AUTO_INCREMENT,akid varchar(100), PRIMARY KEY ("id"))"
mysql -u root -p -D khotfix_test  -e "${create_table_sql}"
