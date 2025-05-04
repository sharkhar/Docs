## Docker Swarm

Docker Swarm is Docker’s native container orchestration tool. It simplifies deployment and management of containers by allowing users to configure and manage clusters of Docker nodes as a single virtual system. With Docker Swarm, you can scale containers and ensure high availability.

### What is Docker Swarm?
- A Swarm is a cluster of Docker nodes (machines).
- There are two types of nodes:
  - Manager nodes: Orchestrate and manage the Swarm.
  - Worker nodes: Execute tasks assigned by the manager.
- Swarm mode supports load balancing, service discovery, rolling updates, and high availability out of the box.

### Install Docker on All Nodes
Install Docker on each machine (Ubuntu/CentOS/etc.), using:

[Docker installation for Linux](https://shardulshekhar.co.in/blogs/docker/)

### Create Swarm on Master
On the manager node, run:
```
docker swarm init
```
or
```
docker swarm init --advertise-addr <MANAGER-IP>
#example:
docker swarm init --advertise-addr 192.168.122.19
```
You’ll get output like this:
```
Swarm initialized: current node (abc123...) is now a manager.

To add a worker to this swarm, run the following command:
  "docker swarm join --token SWMTKN-1-4utn2rljj43dnixqbgpnwv8peuid25m5j0od2oeahjcdw123i9-72pv0zjr14a3qt6karbfmet4d 192.168.122.19:2377"

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

### Join Worker Nodes
On each worker node, run the docker swarm join command you got above:
```
docker swarm join --token SWMTKN-1-4utn2rljj43dnixqbgpnwv8peuid25m5j0od2oeahjcdw123i9-72pv0zjr14a3qt6karbfmet4d 192.168.122.19:2377
```
To retrieve the join command including the join token for worker nodes, run command on a manager node:
```
docker swarm join-token worker
```
You’ll get output like this:
```
To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.122.19:2377

This node joined a swarm as a worker.
```

### Join Manager nodes
To view the join command and token for manager nodes, run:
```
docker swarm join-token manager
```
You’ll get output like this:
```
To add a manager to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-59egwe8qangbzbqb3ryawxzk3jn97ifahlsrw01yar60pmkr90-bdjfnkcflhooyafetgjod97sz \
    192.168.99.100:2377
```
Run the output command on the new node that needs to be joined in the swarm as manager node.

### node on the swarm
Now the nodes are the part of the Swarm. Verify that all your nodes are actively available.
```
docker node ls
```
You’ll get output like this:
```
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
1bcef6utixb0l0ca7gxuivsj0    worker2   Ready   Active
38ciaotwjuritcdtn9npbnkuz    worker1   Ready   Active
e216jshn25ckzbvmwlnh5jr3g *  manager1  Ready   Active        Leader
```

### Make node Manager
Promotes a node to manager. This command can only be executed on a manager node.
```
docker node promote `<worker node>`
```
or
```
docker node update --role manager
```

### Remove from manager
Demote a node from manager to worker. This command can only be executed on a manager node.
```
docker node demote `<worker node>`
```
or
```
docker node update --role worker
```

### Remove node from cluster
Removes the specified nodes from a swarm. A manager node must be demoted to a worker node (using docker node demote) before you can remove it from the swarm.
```
 $ docker node rm `<node>`
```
When you run this command on a worker, that worker leaves the swarm.
```
docker swarm leave
```

### Drain a node
Sometimes, such as planned maintenance times, you need to set a node to Drain availability. Drain availability prevents a node from receiving new tasks from the swarm manager. It also means the manager stops tasks running on the node and launches replica tasks on a node with Active availability.

```
docker node update --availability drain worker1
```
Inspect the node to check its availability:
```
docker node inspect --pretty worker1

ID:			38ciaotwjuritcdtn9npbnkuz
Hostname:		worker1
Status:
 State:			Ready
 Availability:		Drain
...snip...
```
### Monitor swarm Health
 From the command line, run _docker node inspect <id-node>_ to query the nodes. For instance, to query the reachability of the node as a manager:
 ```
docker node inspect manager1 --format "{{ .ManagerStatus.Reachability }}"
 reachable
```
To query the status of the node as a worker that accept tasks:
```
docker node inspect manager1 --format "{{ .Status.State }}"
 ready
```
</br></br></br>
Let me know if you need help with anything else related to Docker!
