## MongoDB

MongoDB is an open source NoSQL database management program. NoSQL (Not only SQL) is used as an alternative to traditional relational databases. NoSQL databases are quite useful for working with large sets of distributed data. MongoDB is a tool that can manage document-oriented information, store or retrieve information.
MongoDB is used for high-volume data storage, helping organizations store large amounts of data while still performing rapidly.

### Create Yum Repo
Create a **/etc/yum.repos.d/mongodb-org-8.0.repo** file so that you can install MongoDB directly using yum. It will be downloading the mongo version **8.0.6**.
```
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
```
**Note :** If the ulimit value for number of open files is under 64000, MongoDB generates a startup warning.

### Installation
```
  sudo yum install -y \
     mongodb-org-8.0.6 \
     mongodb-org-database-8.0.6 \
     mongodb-org-server-8.0.6 \
     mongodb-mongosh \
     mongodb-org-mongos-8.0.6 \
     mongodb-org-tools-8.0.6 \
     mongodb-org-database-tools-extra-8.0.6
```

### Start Service
1. You can start the mongod process by issuing the following command:
```
sudo systemctl start mongod
```
&emsp;If you receive an error similar to the following when starting mongod:

&emsp;__Failed to start mongod.service: Unit mongod.service not found.__

&emsp;Run the following command first:
```
sudo systemctl daemon-reload
```
2. You can verify that the mongod process has started successfully by issuing the following command:
```
  sudo systemctl status mongod
```
3. You can optionally ensure that MongoDB will start following a system reboot by issuing the following command:
```
  sudo systemctl enable mongod
```
4. You can restart the mongod process by issuing the following command:
```
sudo systemctl restart mongod
```

### Uninstall
To completely remove MongoDB from a system, you must remove the MongoDB applications themselves, the configuration files, and any directories containing data and logs. The following section guides you through the necessary steps.

**Warning** : _This process will completely remove MongoDB, its configuration, and all databases. This process is not reversible, so ensure that all of your configuration and data is backed up before proceeding._

1. Stop the mongod process by issuing the following command:
```
sudo service mongod stop
```
2. Remove any MongoDB packages that you had previously installed.
```
sudo yum erase $(rpm -qa | grep mongodb-org)
```
3. Remove MongoDB databases and log files.
```
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongo
```
### Login
By default, MongoDB launches with bindIp set to 127.0.0.1, which binds to the localhost network interface. This means that the mongod can only accept connections from clients that are running on the same machine.
```
mongosh --host=localhost --port=27017
```

### Create User
```
use admin;
db.createUser(
{
user: "dev",
pwd: "pass#123",
roles: [ { role: "root", db: "admin" } ]
}
)
```
### Show Users
```
use admin;
show users;
```

### Authentication
```
    sudo vi /lib/systemd/system/mongod.service

   ...
   Environment="OPTIONS= --auth -f /etc/mongod.conf"
   ....

   $ sudo systemctl daemon-reload
   $ sudo systemctl restart mongod
```

   or

```
sudo vi /etc/mongod.conf

security:
  authorization: enabled
```

### Loging In MongoDB 
create a folder on /tmp and take backup using below command
```
mongos --host=localhost --port=27017 --username=dev --password=pass#123 --authenticationDatabase=admin
```

### Create DATABASE
```
> use DATABASE_NAME
> db
> db.movie.insert({"name":"tutorials point"})
> show dbs
> quit()
```
</br></br></br>
Have trouble with installation? Drop a comment or reach out.
