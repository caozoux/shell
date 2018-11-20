#!/usr/bin/python2.7

import os
import re
import requests
from optparse import OptionParser
from multiprocessing import cpu_count
import urllib2
from bs4 import BeautifulSoup
import pymysql

db=""

def sql_connect():
    return pymysql.connect(host='127.0.0.1',
                           port=3306,
                           user='root',
                           password='123456',
                           database='khotfix_test',
                           charset='utf8')

def sql_insert(rpminfo_list):
    "insert rpminfo to db"

    #jinsert_table_sql="INSERT INTO rpmpackages_debug(`akid`,`kernel`,`rpmname`,`downlink`) SELECT '%s','%s','%s','%s' FROM DUAL WHERE NOT EXISTS(SELECT downlink FROM rpmpackages_debug WHERE downlink='%s');"%(rpminfo_list[0], rpminfo_list[1], rpminfo_list[2], rpminfo_list[3], rpminfo_list[3])
    insert_table_sql="INSERT INTO rpmpackages_debug(`akid`,`kernel`,`rpmname`,`downlink`) SELECT '%s','%s','%s','%s' FROM DUAL WHERE NOT EXISTS(SELECT downlink FROM rpmpackages_debug WHERE downlink='%s');"%(rpminfo_list[0], rpminfo_list[1], rpminfo_list[2], rpminfo_list[3], rpminfo_list[3])

    cursor = db.cursor()
    try:
        cursor.execute(insert_table_sql)
        db.commit()
    except:
        print("Error: unable to fecth data")

    #print rpminfo_list[0], rpminfo_list[1], rpminfo_list[2], rpminfo_list[3]


def splite_rpm_downlink(down_link):
    """splite rpm down link to list like ['D521816', '010.ali3000', 'kernel-hotfix-D521816-010.ali3000.ecsvm-1.0-1.alios7.x86_64.rpm'
    , "http://yum.tbsite.net/taobao/7/x86_64/current/kernel-hotfix-D521816-012.ali3000/kernel-hotfix-D521816-012.ali3000-1.0-1.alios7.x86_64.rpm"]"""

    rpminfo_list=[]
    list_array=down_link.split("/")
    rpm_name=list_array[-1]
    print rpm_name
    akid=rpm_name.split("-")[2]
    kernel=rpm_name.split("-")[3]
    rpminfo_list.append(akid)
    rpminfo_list.append(kernel)
    rpminfo_list.append(rpm_name)
    rpminfo_list.append(down_link)
    return rpminfo_list

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("-a", "--akid",
                      action="store",  dest="akid",
                      help="rpm akid name for searching",
                      )
    (options, args) = parser.parse_args()

    db=sql_connect()
    url = "http://rpm.corp.taobao.com/find.php?q="+options.akid+"&t=&d=0&os="
    req = requests.session()
    response = req.get(url, headers="", verify=False)
    html_test = response.text
    soup = BeautifulSoup(html_test)
    #print soup.prettify()
    #for item in soup.findAll('a'):
    #    print item

    for item in soup.findAll(href=re.compile("^\?t=&")):
        #get rpm link
        rpm_link="http://rpm.corp.taobao.com/find.php?"+item['href']
        response = req.get(rpm_link, headers="", verify=False)
        rpm_html = response.text
        rpm_soup = BeautifulSoup(rpm_html)
        down_link=rpm_soup.findAll(href=re.compile("^http://yum"))[1]
        print down_link['href']
        rpminfo_list=splite_rpm_downlink(down_link['href'])
        sql_insert(rpminfo_list)
    db.close()


