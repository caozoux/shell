#docker build --rm -t centos:systemd .
#run docker: docker run --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -h vmdocker -p 9920:20 -t systemd
#nsenter --mount --uts --ipc --net --pid --target $(docker inspect --format "{{.State.Pid}}" "605bae76456d")
FROM centos:latest
MAINTAINER feisky
RUN yum -y install systemd systemd-libs openssh-server passwd
#RUN yum -y update
RUN yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; \
do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
RUN echo "root:123" | chpasswd
RUN systemctl enable sshd.service
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
