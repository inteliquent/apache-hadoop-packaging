Apache Hadoop Packaging
=======================

This repository contains everything necessary to build a hadoop 3.2.0 debian package and docker container.

*Note: The debian archive and instructions outlined in this README have only be tested on Ubuntu 16.xx*

### Clone This Repository

Get started by cloning this repository. This may take a while...

```
$] git clone https://github.com/inteliquent/apache-hadoop-packaging.git
```

### Build A Hadoop Debian Archive

Building the Debian Archive is very straight forward.

```
$] cd apache-hadoop-packaging
$] dpkg-deb --build hadoop-3.2.0
```

Once the archive is ready it can be installed using the following command.

```
$] sudo dpkg -i hadoop-3.2.0.deb
```

Hadoop will be installed into the `/usr/local` directory.

Finally, the following systemd scripts have been provided for convenience.

- hadoop-datanode.service
- hadoop-historyserver.service
- hadoop-namenode.service
- hadoop-nodemanager.service
- hadoop-resourcemanager.service
- hadoop-webappproxy.service

None of the services run by default but that can be changed using the following command.

```
$] systemd enable hadoop-${SERVICE_NAME}.service
```

To start a service use the following command.

```
$] systemd start hadoop-${SERVICE_NAME}.service
```

*Note: ${SERVICE_NAME} should be replaced with the desired service name e.g. datanode*

### Build A Hadoop Docker Container

```
$] cd apache-hadoop-packaging
$] docker build -t inteliquent/apache-hadoop:3.2.0 .
```

### Deploying A Hadoop Container

The following environment variables are used to initialize an Apache Hadoop Container.

- HADOOP_CLUSTER_NAME This variable contains the Apache Hadoop cluster name and is required when $HADOOP_NAME_NODE_INIT is set to true. (Optional)
- HADOOP_NAME_NODE_INIT This variable when set to true will format the HDFS filesystem. (Optional)
- HADOOP_NODE_TYPE This variable contains the specialization of a container. Possible options are `datanode`, `historyserver`, `namenode`, `nodemanager`, `resourcemanager` and `webappproxy`.

To run a name node container just run the following command.

```
$] sudo docker run -d --name hadoop -e HADOOP_NODE_TYPE=namenode -v /etc/hadoop:/etc/hadoop voyant/hadoop:3.2.0
```

*Note: If the host folder `/etc/hadoop` is empty the container will write a set of default config files and exit. Once the files are updated restart the container and the selected specialization will run with the updated config files.*

For more information on how to deploy an Apache Hadoop cluster please visit the [project site](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/ClusterSetup.html).
