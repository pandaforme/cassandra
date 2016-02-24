# Cassandra
#
# VERSION               1.0

FROM centos:centos6

# Add source repositories
ADD src/epel6.repo /etc/yum.repos.d/epel6.repo
ADD src/datastax.repo /etc/yum.repos.d/datastax.repo

# Install Java, Install packages (sshd + supervisord + monitoring tools + cassandra)
RUN yum -y groupinstall "Development Tools"
RUN yum -y install erlang gcc gcc-c++ kernel-devel-`uname -r` make perl sqlite-devel
RUN yum -y install bzip2 bzip2-devel zlib-devel
RUN yum -y install ncurses-devel readline-devel tk-devel
RUN yum -y install net-tools nfs-utils openssl-devel
RUN yum -y install git screen tmux wget zsh
RUN yum install -y wget tar openssh-server openssh-clients supervisor sysstat sudo which openssl hostname
RUN yum install -y dsc22
RUN yum clean all

# install python 2.7
ENV PYTHON_VERSION 2.7.9
RUN wget -O Python-${PYTHON_VERSION}.tar.xz http://python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz && tar -xf Python-${PYTHON_VERSION}.tar.xz
RUN cd Python-${PYTHON_VERSION} && ./configure --prefix=/usr/local && make && make altinstall
RUN rm -rf Python*
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python
RUN echo "/usr/lib/python2.7/site-packages" | tee /usr/local/lib/python2.7/site-packages/cqlshlib.pth

ENV JAVA_VERSION 8u31
ENV BUILD_VERSION b13

# Downloading Java
RUN \
    wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm && \
    yum -y install /tmp/jdk-8-linux-x64.rpm && \
    rm /tmp/jdk-8-linux-x64.rpm 

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
ENV JAVA_HOME /usr/java/latest

# Configure SSH server
# Create OpsCenter account
RUN mkdir -p /var/run/sshd && chmod -rx /var/run/sshd && \
	ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key && \
	sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
	useradd -m -G users,root -p $(openssl passwd -1 "opscenter") opscenter && \
	echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure supervisord
ADD src/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor

# Deploy startup script
ADD src/start.sh /usr/local/bin/start

# Necessary since cassandra is trying to override the system limitations
# See https://groups.google.com/forum/#!msg/docker-dev/8TM_jLGpRKU/dewIQhcs7oAJ
RUN rm -f /etc/security/limits.d/cassandra.conf

EXPOSE 7199 7000 7001 9160 9042
EXPOSE 22 8012 61621
USER root
CMD start
