FROM ubuntu:16.04

# Add the OpenJDK repository.
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa

# Install Hadoop dependencies.
RUN apt-get update && apt-get install -y curl openjdk-8-jdk rsync ssh

# Set the JAVA_HOME environment variable.
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Install Hadoop.
RUN curl https://s3.amazonaws.com/voyantpublic/hadoop-3.2.0.deb -o /root/hadoop-3.2.0.deb
RUN dpkg -i /root/hadoop-3.2.0.deb && rm -f /root/hadoop-3.2.0.deb

# Set the container's entry point.
COPY hadoop-entrypoint.sh /usr/local/bin/hadoop-entrypoint.sh
RUN chmod +x /usr/local/bin/hadoop-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/hadoop-entrypoint.sh"]