Apache Hadoop Container
=======================

### Build An Apache Hadoop Container

```
$] docker build -t voyant/apache-hadoop .
```

### Deploying A Hadoop Container

The following environment variables are used to initialize an Apache Hadoop Container.

- HADOOP_CLUSTER_NAME This variable contains the Apache Hadoop cluster name and is required when $HADOOP_NAME_NODE_INIT is set to true. (Optional)
- HADOOP_NAME_NODE_INIT This variable when set to true will bootstrap the Apache Hadoop cluster. (Optional)
- HADOOP_NODE_TYPE This variable contains the specialization of a container. Possible options are `datanode`, `historyserver`, `namenode`, `nodemanager`, `resourcemanager` and `webappproxy`.

To run a name node container just run the following command.

```
$] sudo docker run -d --name namenode -e HADOOP_NODE_TYPE=namenode -v /etc/hadoop:/etc/hadoop voyant/apache-hadoop
```

*Note: If the host folder `/etc/hadoop` is empty the container will write a set of default config files and exit. Once the files are updated restart the container and the selected specialization will run with the updated configuration.*

*Note: The container expects the logs to be stored in the `/var/log/hadoop` folder. Keep that in mind when updating the configuration files.*

For more information on how to deploy an Apache Hadoop cluster please visit the [project site](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/ClusterSetup.html).
