## Kafka Single node

This lab will guide you through the steps of setting up Apache Kafka and using it to facilitate centralized logging and real-time monitoring in a DevOps environment. By the end of this lab, you’ll understand how Kafka can be used to enhance communication between microservices, centralize logs, and provide a robust event streaming solution for your infrastructure.

### Prerequisites:
Before starting, ensure you have the following:
- Basic understanding of Kafka concepts (topics, producers, consumers, brokers)
- Installed and configured:
  - **Java 8+** (required to run Kafka)
  - **Apache Zookeeper** (used by Kafka for coordination)
  - **Docker** (optional, but useful for containerized deployment)

### Tools:
- Apache Kafka (version 2.8.0 or later)
- Apache Zookeeper (to manage Kafka cluster)
- Docker (if using containerized deployment)
- Linux or MacOS (or a Linux-compatible environment like WSL on Windows)

## 1. Stop Firewall and selinux
Before setting up Kafka and Zookeeper, it’s important to stop the firewall and disable SELinux to avoid conflicts:
 - Check the status of the firewall
 ```
systemctl status firewalld
```
 - Stop the firewall
```
systemctl stop firewalld
```
 - Disable the firewall to prevent it from starting on boot
```
systemctl disable firewalld
```
 - Disable SELinux temporarily
```
setenforce 0
```
 - Permanently disable SELinux by editing its config file
```
vim /etc/selinux/config
# Change SELINUX=enforcing to SELINUX=disabled
```

## 2. Zookeeper Configuration
 Zookeeper is essential for managing Kafka nodes, so we need to configure it first.

### 2.1 Download Zookeeper
 You can download Zookeeper from its official website:

  [Download the zookeeper](https://zookeeper.apache.org/releases.html)

After downloading, extract the files:
```
- cd /opt
- tar -xvf apache-zookeeper-3.8.4-bin.tar.gz
- cd /opt/apache-zookeeper-3.8.4-bin
```
 
### 2.2 Configure Zookeeper
Now, configure Zookeeper by editing the zoo.cfg file:
```
vim /opt/apache-zookeeper-3.8.4-bin/conf/zoo.cfg
```
Add the following configuration:
```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/zookeeper-data
clientPort=2181
maxClientCnxns=60
  
acks=all
retries=3
batch.size=16384
linger.ms=1
buffer.memory=33554432
auto.offset.reset=latest
enable.auto.commit=true
auto.commit.interval.ms=5000

4lw.commands.whitelist=*
#4lw.commands.whitelist=stat, ruok, conf, isro
server.1=<node1>:2700:3788
```

### 2.3 Set Zookeeper ID for Each Node
 Zookeeper assigns each node in the cluster a unique ID. For example, to set the ID for node 1:
```
mkdir /opt/zookeeper
touch /opt/zookeeper/myid
echo 1 > /opt/zookeeper/myid
cat /opt/zookeeper/myid
```
 
### 2.4 Create Zookeeper Service
Create a systemd service to manage Zookeeper:
```
vim /etc/systemd/system/zookeeper.service
```
Add the following content:
```
[Unit]
Description=Apache Zookeeper server
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target
After=network.target remote-fs.target
 
[Service]
Type=forking
ExecStart=/opt/apache-zookeeper-3.8.4-bin/bin/zkServer.sh start
ExecStop=/opt/apache-zookeeper-3.8.4-bin/bin/zkServer.sh stop
 
[Install]
WantedBy=multi-user.target
```

### 2.5 Start Zookeeper Service
Run the following commands to start Zookeeper:
```
systemctl daemon-reload
systemctl start zookeeper.service
systemctl status zookeeper.service
```

- *This need to be done on all servers if you are creating a kafka cluster.* 
- *ID will be changes respectively.*
 
## 3. Kafka Configuration
### 3.1 Download Kafka
Download the latest version of Kafka from the official website:

  [Download kafka](https://kafka.apache.org/downloads)

Extract the downloaded file:
```
cd /opt
# Extract Kafka version (update version as needed)
tar -xvf kafka_2.13-3.7.0.tgz
cd /opt/kafka_2.13-3.7.0
```
### 3.2 Configure Kafka
Edit the server.properties file to configure Kafka:
```
vim /opt/kafka_2.13-3.7.0/config/server.properties
```
 Add or modify the following properties:
```
broker.id=1 # change broker id accordingly
listeners=PLAINTEXT://<node1>:9092
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
log.dirs=/opt/kafka-logs
num.partitions=3
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
default.replication.factor=3
min.insync.replicas=2
unclean.leader.election.enable=false
log.flush.interval.messages=10000
log.flush.interval.ms=1000
replica.fetch.max.bytes=1048576
replica.fetch.wait.max.ms=500
replica.fetch.min.bytes=1
zookeeper.connect=<node1>:2181
zookeeper.connection.timeout.ms=18000
group.initial.rebalance.delay.ms=0
delete.topic.enable=true
```

### 3.3 Create Kafka Service
Create a systemd service for Kafka:
```
vim /etc/systemd/system/kafka.service
```
Add the following content:
```
[Unit]
Description=Apache kafka server
Documentation=http://kafka.apache.org
Requires=network.target remote-fs.target
After=network.target remote-fs.target
 
[Service]
Type=forking
ExecStart=/opt/kafka_2.13-3.7.0/bin/kafka-server-start.sh -daemon /opt/kafka_2.13-3.7.0/config/server.properties
ExecStop=/opt/kafka_2.13-3.7.0/bin/kafka-server-stop.sh -daemon /opt/kafka_2.13-3.7.0/config/server.properties
 
[Install]
WantedBy=multi-user.target
```
### 3.4 Start Kafka Service
Start the Kafka service using the following commands:
```
systemctl daemon-reload
systemctl start kafka.service
systemctl status kafka.service
```

## Conclusion
By following these steps, you will have successfully set up Apache Kafka and Zookeeper for centralized logging and real-time monitoring in a DevOps environment. Kafka can now be used to stream events and log data, improving communication between microservices and enhancing infrastructure monitoring.
