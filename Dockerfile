FROM ubuntu:utopic
MAINTAINER Bobby Powers <bobbypowers@gmail.com>

ENV TERM linux

# Install Java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu utopic main" >/etc/apt/sources.list.d/webupd8team-java.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
	apt-get update && \
	apt-get install -y curl sudo

# Preemptively accept the Oracle License, install the JDK & enable JNA
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	apt-get install -y oracle-java8-installer oracle-java8-set-default && \
	curl -L -o /usr/lib/jvm/java-8-oracle/jre/lib/ext/jna.jar https://github.com/twall/jna/raw/master/dist/jna.jar

# Install Cassandra
RUN echo "deb http://debian.datastax.com/community stable main" >/etc/apt/sources.list.d/datastax.list && \
	curl -L http://debian.datastax.com/debian/repo_key | apt-key add - && \
	apt-get update && \
	apt-get install -y dsc21 && \
	rm -rf /var/lib/apt/lists/*

ADD cassandra-start /usr/sbin/
RUN chown root:root /usr/sbin/cassandra-start && \
	chmod 755 /usr/sbin/cassandra-start

# Storage port, encrypted storage, JMX, CQL Native
EXPOSE 7000 7001 7199 9042

VOLUME ["/var/lib/cassandra", "/var/log/cassandra"]

CMD cassandra-start
