#!/bin/bash

function init_hdfs {
    if [ -n "$HADOOP_NAME_NODE_INIT" ]; then
        if [ $(echo "$HADOOP_NAME_NODE_INIT" | tr '[:upper:]' '[:lower:]') == "true" ]; then
            if [ -n "$HADOOP_CLUSTER_NAME" ]; then
                hdfs namenode -format "$HADOOP_CLUSTER_NAME"
            else
                echo "The environment variable HADOOP_CLUSTER_NAME must be defined to initialize the name node."
                exit 1
            fi
        fi
    fi
}

# Create the config directory if it doesn't exist.
if [ ! -d /etc/hadoop ]; then
    mkdir -p /etc/hadoop
fi

# If the config directory is empty copy vanilla config files
# to the config directory and give the user an opportunity to
# configure the container.
if [ "$(ls -A /etc/hadoop | wc -l)" -eq "0" ]; then
    cp -varf /usr/local/share/hadoop/config/* /etc/hadoop
    echo "A vanilla configuration file set has been copied into the configuration folder."
    echo "Please update the configuration files and restart the container."
    exit 1
fi

# Specialize the container.
case "$HADOOP_NODE_TYPE" in
    namenode)
        init_hdfs
        systemd start hadoop-namenode.service
        systemd status hadoop-namenode.service
        ;;
    resourcemanager)
        systemd start hadoop-resourcemanager.service
        systemd status hadoop-resourcemanager.service
        ;;
    datanode)
        systemd start hadoop-datanode.service
        systemd status hadoop-datanode.service
        ;;
    nodemanager)
        systemd start hadoop-nodemanager.service
        systemd status hadoop-nodemanager.service
        ;;
    historyserver)
        systemd start hadoop-historyserver.service
        systemd status hadoop-historyserver.service
        ;;
    webappproxy)
        systemd start hadoop-webappproxy.service
        systemd status hadoop-webappproxy.service
        ;;
    *)
        echo "Environment variable HADOOP_NODE_TYPE must be one of the following: {namenode|resourcemanager|datanode|nodemanager}"
        exit 1
esac

exit 0