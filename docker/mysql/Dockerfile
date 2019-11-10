#docker build -t http_server .
##run docker: docker run --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -h server.http.local -p 8081:80 -t http_server 
FROM centos:systemd
MAINTAINER feisky
RUN yum -y install httpd; systemctl enable httpd.service
RUN yum -y install mariadb-server mariadb; systemctl enable mariadb.service
RUN yum clean all
EXPOSE 80
CMD ["/usr/sbin/init"]
