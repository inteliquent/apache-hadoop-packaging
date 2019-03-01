FROM ubuntu:xenial

RUN apt update && \
    # Add the OpenJDK Repository.
    apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    # Install OpenJDK 8.
    apt update && \
    apt install --no-install-recommends -y curl openjdk-8-jdk rsync ssh && \
    rm -rf /var/lib/apt/lists/* && \
    # Download the latest stable Apache Hadoop version.
    curl -o /tmp/hadoop-2.9.2.tar.gz http://mirrors.ibiblio.org/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz && \
    cd /tmp && \
    tar xzvf hadoop-2.9.2.tar.gz && \
    rm hadoop-2.9.2.tar.gz && \
    # Create a debian package for Apache Hadoop.
    cd hadoop-2.9.2 && \
    rm LICENSE.txt && \
    rm NOTICE.txt && \
    rm README.txt && \
    mkdir -p usr/local && \
    mv bin usr/local/ && \
    mv etc usr/local/ && \
    mv include usr/local/ && \
    mv lib usr/local/ && \
    mv libexec usr/local/ && \
    mv sbin usr/local/ && \
    mv share usr/local/ && \
    mkdir DEBIAN && \
    cd DEBIAN && \
    echo "Package: hadoop\n\
Version: 2.9.2\n\
Maintainer: Thomas Quintana <thomas.quintana@voyant.com>\n\
Architecture: all\n\
Description: The Apache Hadoop software library is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models.\n\
Depends: openjdk-8-jdk, rsync, ssh" > control && \
    echo "#!/bin/bash\n\n\
ldconfig -v" > postinst && \
    chmod 0555 postinst && \
    cd /tmp && \
    dpkg-deb --build hadoop-2.9.2 && \
    rm -rf /tmp/hadoop-2.9.2 && \
    # Install Apache Hadoop.
    dpkg -i hadoop-2.9.2.deb && \
    rm -rf /tmp/hadoop-2.9.2.deb

# Configure the environment.
ENV HADOOP_HOME=/usr/local
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Set the container's entry point.
COPY hadoop-entrypoint.sh /usr/local/bin/hadoop-entrypoint.sh
RUN chmod +x /usr/local/bin/hadoop-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/hadoop-entrypoint.sh"]