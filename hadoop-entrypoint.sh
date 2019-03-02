#!/bin/bash

function init_hdfs {
    if [ "${HADOOP_NODE_TYPE}" == "namenode" ]; then
        if [ -n "${HADOOP_CLUSTER_NAME}" ]; then
            hdfs namenode -format "${HADOOP_CLUSTER_NAME}"
        else
            echo "The environment variable HADOOP_CLUSTER_NAME must be defined to initialize the cluster."
            exit 1
        fi
    fi
}

function update_sshd_port {
    if [ "${HADOOP_NODE_TYPE}" == "datanode" ] || [ "${HADOOP_NODE_TYPE}" == "nodemanager" ]; then
        if [ -n "${SSHD_PORT}" ]; then
            sed -i "s/Port 22/Port ${SSHD_PORT}/g" /etc/ssh/sshd_config
            systemctl stop ssh
            systemctl start ssh
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
    cp -varf /usr/local/etc/hadoop/* /etc/hadoop
    echo "A vanilla configuration file set has been copied into the configuration folder."
    echo "Please update the configuration files and restart the container."
    exit 1
fi

# Specialize the container.
case "${HADOOP_NODE_TYPE}" in
    namenode)
        systemctl stop ssh
        systemctl disable ssh
        if [ -n "${HADOOP_NAME_NODE_INIT}" ]; then
            if [ $(echo "${HADOOP_NAME_NODE_INIT}" | tr '[:upper:]' '[:lower:]') == "true" ]; then
                if [ ! -f "/etc/hadoop/firstboot" ]; then
                    init_hdfs
                    touch /etc/hadoop/firstboot
                fi
            fi
        fi
        hadoop-daemon.sh --script hdfs start namenode
        tail -f $(find /var/log/hadoop -name hadoop*namenode*.out)
        ;;
    resourcemanager)
        systemctl stop ssh
        systemctl disable ssh
        yarn-daemon.sh start resourcemanager
        tail -f $(find /var/log/hadoop -name yarn*resourcemanager*.out)
        ;;
    datanode)
        update_sshd_port
        hadoop-daemons.sh --script hdfs start datanode
        tail -f $(find /var/log/hadoop -name hadoop*datanode*.out)
        ;;
    nodemanager)
        update_sshd_port
        yarn-daemons.sh start nodemanager
        tail -f $(find /var/log/hadoop -name yarn*nodemanager*.out)
        ;;
    historyserver)
        systemctl stop ssh
        systemctl disable ssh
        mr-jobhistory-daemon.sh start historyserver
        tail -f $(find /var/log/hadoop -name mapred*historyserver*.out)
        ;;
    webappproxy)
        systemctl stop ssh
        systemctl disable ssh
        yarn-daemon.sh start proxyserver
        tail -f $(find /var/log/hadoop -name yarn*proxyserver*.out)
        ;;
    *)
        echo "Environment variable HADOOP_NODE_TYPE must be one of the following: {namenode|resourcemanager|datanode|nodemanager|historyserver|webappproxy}"
        exit 1
esac

exit 0