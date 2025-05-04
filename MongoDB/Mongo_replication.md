## MongoDB Replication

One of MongoDB’s superpowers is its built-in replication feature. Whether you're building a mission-critical app or simply want to avoid data loss, MongoDB replication ensures your data is always available—even during failures.

In this blog, we’ll break down what MongoDB replication is, how it works, and why you should care—all without getting lost in tech jargon. Let’s dive in.

Replication is the process of synchronizing data across multiple MongoDB servers. A replica set is a group of mongod instances that maintain the same dataset.

At any given time:
- One node is the primary – it receives all write operations.
- Others are secondaries – they replicate the primary’s data asynchronously.

### Replica Set Architecture
If the primary goes down, one of the secondaries gets automatically promoted, keeping your database highly available and fault-tolerant.

- Primary: Handles all writes and reads (unless read preferences change that).
- Secondaries: Continuously replicate data via the oplog (operations log).
- Arbiter (optional): Participates in elections but doesn't store data.

###  Why Use Replication?
- **High Availability:** Your app stays online even if one server fails.
- **Data Redundancy:** Multiple copies mean lower risk of data loss.
- **Read Scalability:** You can direct read traffic to secondary nodes (if your app supports eventual consistency).
- **Disaster Recovery:** Backups and failover become much easier.
### Key Authentication

```
mkdir ~/mongo-security
d ~/mongo-security/
openssl rand -base64 756 > keyfile.txt
chmod 400 keyfile.txt
sudo chown mongod:mongod /var/lib/mongo/keyfile.txt
sudo vi /etc/mongod.conf
security:
   keyFile: /var/lib/mongo/keyfile.txt
    # transitionToAuth: true
```

### Replication
```
   ->   replication:rs0
   $ service mongod restart

> rs.initiate()
> rs.add("192.168.122.27")
> rs.conf()
> rs.status()
```
### Replication setings

* Priority

```
> cfg = rs.conf()
> cfg.members[0].priority = 1
> cfg.members[1].priority = 0
> rs.reconfig(cfg)
```

* Election

```
> cfg = rs.conf()
> cfg.members[0].votes = 1
> cfg.members[1].votes = 0
> rs.reconfig(cfg)
```

### Wrapping Up
MongoDB replication is one of its strongest features, making it a solid choice for high-availability, distributed applications. Once set up, it helps your app stay resilient, even when hardware fails.
</br></br></br>
Have questions or want help designing your MongoDB deployment? Drop a comment or reach out let’s keep your data safe and accessible!
