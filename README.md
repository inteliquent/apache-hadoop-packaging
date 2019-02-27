Apache Hadoop Packaging
=======================

This repository contains everything necessary to build a hadoop 3.2.0 debian package and docker container.

**Note: The debian archive and instructions outlined in this README have only be tested on Ubuntu 16.xx**

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

### Build A Hadoop Docker Container

```
$] cd apache-hadoop-packaging
$] docker build -t voyant/hadoop:3.2.0 .
```

### Deploying A Hadoop Container

```

```