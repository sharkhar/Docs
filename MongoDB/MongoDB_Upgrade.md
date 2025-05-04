## MongoDB Upgrade

Upgrading your MongoDB instance is crucial to keeping your database secure, performant, and feature-rich. Whether you're moving from an older 4.x version to 6.0 or transitioning to MongoDB Atlas, a well-planned upgrade can save you from unexpected downtime or compatibility issues.

In this post, we’ll walk you through the best practices, tools, and steps you need to upgrade MongoDB smoothly.

### Why Upgrade
Before diving into the how, let's understand the why:

1. **Security:** New versions patch vulnerabilities and provide stronger authentication/authorization.
2. **Performance:** Improved indexing, better aggregation performance, and smarter query planners.
3. **Features:** Each version brings new features—like time series collections, change streams, or native sharding improvements.
4. **Support:** MongoDB Inc. phases out support for older versions, which could leave your system exposed.

### Upgrade
Follow step by step to upgrade MongoDB. First you need to check what mongo version you are using it will help you understand the upgradation.
```
mongod --version
```
Make sure you know your exact starting point to determine if an intermediate upgrade step is required.

**Example:** You can’t jump directly from 4.0 to 6.0. You’ll need to go from 4.0 → 4.2 → 4.4 → 5.0 → 6.0.

### Backup
you need to take full backup of your mongo database, so that once you upgrade you database you can restore it. so you will have same data at the end of upgradation. first create a folder on /tmp  with name _upgrade_. The name of the directory or location can be of you choice but make sure to use the same path in you command to store the dump. Take backup using below command

```
mongodump --host=localhost --port=27017 --username=dev --password=pass#123 --authenticationDatabase=admin --out=/tmp/upgrade
```

### Stop the mongod services
Upgrades to a running MongoDB Server process can have unexpected results. Before you begin, stop the existing mongod process. To stop the mongod process, run the following command:
```
sudo systemctl stop mongod
```

### Remove Current Mongo Package
To remove MongoDB Community Server from rpm command use the following command:
check mongo packages install on server:
```
rpm -qa |grep mongo
```
now remove all the packages using below commands:
```
rpm -e <package name>
```
If you installed MongoDB Community Server with a package manager on Linux, you must remove the existing packages before you install MongoDB Enterprise Server.

To remove MongoDB Community Server from RHEL, CentOS, Alma Linux, Oracle, Rocky, and Amazon Linux, run the following command:
```
sudo dnf remove $(sudo rpm -qa | grep mongodb-org)
```
To remove MongoDB Community Server from Ubuntu and Debian, run the following command:
```
sudo apt remove mongodb-org\*
```

### Install New Package
Depending on your operating system, you can install the MongoDB binaries by using a package manager or by downloading the binaries manually.
```
rpm -ivh <package name>
```
Upgrade the MongoDB Binaries On Ubuntu/Debian:
```
sudo apt-get install -y mongodb-org
```
On RedHat/CentOS:
```
sudo yum install -y mongodb-org
```
Always use the [official MongoDB upgrade guide](https://www.mongodb.com/docs/manual/release-notes/) for OS-specific instructions.

### Start Mongo Service
To start MongoDB Server, run the following commands:
```
systemctl start mongod
systemctl enable mongod
systemctl status mongod
```
check new mongodb version after the upgradation:
```
mongod --versions
```
Monitor logs for any issues:
```
tail -f /var/log/mongodb/mongod.log
```

### Create New User
To add authentication you need to first login into mongodb and then create a user in the admin db present in mongodb. Follow below commands to create a user in mongodb
```
mongosh 
use admin;
db.createUser({user: "dev",pwd:"pass#123", roles: [{role: "root", db: "admin" }]})
```

### Authenciation
Once you have created the user in the mongodb you can now enable the authentication so that user can only access db and perform operation using the above created user. To do so you need to add below entries on **/etc/mongod.conf** file.
```  
net:
  port: 27017
 
  bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.


security:
  authorization: enabled
```

### Restart
Once the authentication is enabled you need to restart the mongo server.
```
systemctl restart mongod
```
sometimes you can get mongodb.sock file error. In that case you can delete the **mongo.sock** present in **/tmp/** path and than restart the service again.

Login with credentials:
```
mongosh --host=localhost --port=27017 --username=dev --password=pass#123 --authenticationDatabase=admin
```

### Restore Mongo
In order to restore the databases present in mongodb before starting the upgradtion. we will use the same mongodump that we have created in the starting in my came which is present in location _/tmp/upgrade/_.

Run below command to restore the databases inside the mongo server.
```
mongorestore --host=localhost --port=27017 --username=dev --password=pass#123 --authenticationDatabase=admin  /tmp/upgrade
```
Check if the data is restored.
```
mongosh --host=localhost --port=27017 --username=dev --password=pass#123 --authenticationDatabase=admin
show dbs;
```

### Wrapping Up
Upgrading MongoDB may feel daunting, but with careful planning and testing, it can be seamless and rewarding. Staying up to date gives you access to better performance, security, and powerful features—so don’t delay!
</br></br></br>
Need help with your upgrade? contact Us for tailored support!
