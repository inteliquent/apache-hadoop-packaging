FROM ubuntu:16.04

# Add the OpenJDK repository.
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa

# Install Hadoop dependencies.
RUN apt-get update && apt-get install -y openjdk-8-jdk rsync ssh

# Set the JAVA_HOME environment variable.
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Install Hadoop.
COPY hadoop-3.2.0 /tmp/hadoop-3.2.0
WORKDIR /tmp
RUN dpkg-deb --build hadoop-3.2.0
RUN dpkg -i hadoop-3.2.0.deb && rm -fr hadoop-3.2.0.deb hadoop-3.2.0
ENV HADOOP_PREFIX=/usr/local

# Set the container's entry point.
COPY hadoop-entrypoint.sh /usr/local/bin/hadoop-entrypoint.sh
RUN chmod +x /usr/local/bin/hadoop-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/hadoop-entrypoint.sh"]