# Dockerfile for installing the necessary dependencies for running Hadoop and Spark

FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get upgrade -y

# install openjdk
RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# install and configure ssh service
RUN apt-get install -y openssh-server \
    && mkdir -p /var/run/sshd

# configure ssh free key access
RUN echo 'root:hadoop' | chpasswd
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" \
    && cat /root/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && echo "HashKnownHosts no" >> ~/.ssh/config \
    && echo "StrictHostKeyChecking no" >> ~/.ssh/config

# Configure tzdata
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN echo "Europe/Bucharest" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# set supervisor
RUN apt-get install -y supervisor xvfb x11vnc tightvncserver fluxbox
RUN mkdir -p /tmp/root-vnc/
ENV RFBAUTH_PASSWORD_FILE=/tmp/root-vnc/passwd
ENV DISPLAY=:0

RUN echo "hadoop" | vncpasswd -f > $RFBAUTH_PASSWORD_FILE
RUN echo "[program:sshd]" >> /etc/supervisor/supervisord.conf \
    && echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/supervisord.conf  && \
	echo "[program:Xvfb]" >> /etc/supervisor/supervisord.conf \
	&& echo "command=/usr/bin/Xvfb $DISPLAY -screen 0 1920x1080x16" >> /etc/supervisor/supervisord.conf && \
	echo "[program:fluxbox]" >> /etc/supervisor/supervisord.conf \
	&& echo "command=/usr/bin/fluxbox" >> /etc/supervisor/supervisord.conf && \
	echo "[program:x11vnc]" >> /etc/supervisor/supervisord.conf \
	&& echo "command=/usr/bin/x11vnc -display $DISPLAY -bg -loop -forever -xkb -rfbauth $RFBAUTH_PASSWORD_FILE" >> /etc/supervisor/supervisord.conf

# install general tools
RUN apt-get install -y iproute2 vim git inetutils-ping netcat libtool autoconf ldconfig build-essential

# Clone protobuf and install it
WORKDIR /root/
RUN git clone https://github.com/protocolbuffers/protobuf.git protobuf
WORKDIR /root/protobuf/
RUN git checkout tags/v2.5.0 && ./autogen.sh && ./configure.sh && make && make check && make install && ldconfig

# Copy hadoop 2.7.4
WORKDIR /root/
ADD hadoop-2.7.4/src/hadoop-dist/target/hadoop-2.7.4 hadoop
ENV HADOOP_HOME=/root/hadoop/
ADD hadoopconf $HADOOP_HOME/etc/hadoop/
RUN $HADOOP_HOME/bin/hdfs namenode -format

# Copy nutch 1.15
WORKDIR /root/
ADD nutch/runtime/deploy nutch
ENV NUTCH_HOME=/root/nutch/

RUN apt-get clean

EXPOSE 22 9000 50020 50030 5900

CMD /usr/bin/supervisord -n
