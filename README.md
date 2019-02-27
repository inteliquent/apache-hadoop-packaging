Apache Hadoop Packaging
=======================

This repository contains everything necessary to build a hadoop 3.2.0 debian package and docker container.

### Clone This Repository

```
$] git clone https://github.com/inteliquent/apache-hadoop-packaging.git
```

### Build Debian Package

```
$] cd hadoop-hadoop-packaging
$] dpkg-deb --build hadoop-3.2.0
```

### Build Docker Container

```
$] cd hadoop-hadoop-packaging
$] docker build -t voyant/hadoop:3.2.0 .
```

### Deploying the Container

```

```