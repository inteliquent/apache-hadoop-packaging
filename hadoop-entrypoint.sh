#!/bin/bash

HADOOP_CONF_DIR=/etc/hadoop

function start_data_node {
    hadoop-daemons.sh --config "$HADOOP_CONF_DIR" --script hdfs start datanode
}

function start_name_node {
    if [ -n "$HADOOP_NAME_NODE_INIT" ] && [ $(echo "$HADOOP_NAME_NODE_INIT" | tr '[:upper:]' '[:lower:]') == "true" ]; then
        if [ -n "$HADOOP_CLUSTER_NAME" ]; then
            hdfs namenode -format "$HADOOP_CLUSTER_NAME"
        else
            echo "The environment variable HADOOP_CLUSTER_NAME must be defined to initialize the name node."
            exit 1
        fi
    fi
    hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --script hdfs start namenode
}

function start_node_manager {
    yarn-daemons.sh --config "$HADOOP_CONF_DIR" start nodemanager
}

function start_resource_manager {
    yarn-daemon.sh --config "$HADOOP_CONF_DIR" start resourcemanager
}

function start_history_server {
    mr-jobhistory-daemon.sh --config "$HADOOP_CONF_DIR" start historyserver
}

function start_web_app_proxy {
    yarn-daemon.sh --config "$HADOOP_CONF_DIR" start proxyserver

}

# Create the config directory if it doesn't exist.
if [ ! -d "$HADOOP_CONF_DIR" ]; then
    mkdir -p "$HADOOP_CONF_DIR"
fi

# If the config directory is empty copy vanilla config files
# to the config directory and give the user an opportunity to
# configure the container.
if [ "$(ls -A "$HADOOP_CONF_DIR" | wc -l)" -eq "0" ]; then
    cp -varf /usr/local/share/hadoop/config/* "$HADOOP_CONF_DIR"
    echo "A vanilla configuration file set has been copied into the configuration folder."
    echo "Please update the configuration files and restart the container."
    exit 1
fi

# Specialize the container.
case "$HADOOP_NODE_TYPE" in
    namenode)
        start_name_node
        ;;
    resourcemanager)
        start_resource_manager
        ;;
    datanode)
        start_data_node
        ;;
    nodemanager)
        start_node_manager
        ;;
    historyserver)
        start_history_server
        ;;
    webappproxy)
        start_web_app_proxy
        ;;
    *)
        echo "Environment variable HADOOP_NODE_TYPE must be one of the following: {namenode|resourcemanager|datanode|nodemanager}"
        exit 1
esac

exit 0