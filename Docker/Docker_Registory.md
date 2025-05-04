## Docker Registry

Creating a private Docker registry server allows you to host your own Docker images, either for internal use or for custom applications. Docker provides a simple way to set up a registry using the registry image, which is an official Docker image that implements a private registry server.

Here’s a step-by-step guide on how to create your own Docker registry server.

## Create a Docker Registry Server

### Install Docker
If you haven’t installed Docker on your machine yet, you need to install Docker first. Here are the installation instructions
- [Docker installation for Linux](https://shardulshekhar.co.in/blogs/docker/)

### create a docker registry server
Docker provides an official registry image to run a private registry. You can pull and run this image as a container on your machine.

To run a private registry container:
```
docker run -d -p 0.0.0.0:5000:5000 --restart=always --name registry registry:2
```

### Verify the Docker Registry Server is Running
You can check if the Docker registry server is running by visiting http://localhost:5000/v2/ (or replace localhost with your server's IP address if you’re not running it locally). You should see a response similar to:
```
{}
```
You can also verify the container's status
```
docker ps
```
This will list the running containers, and you should see the registry container.

## daemon.json
On most Linux systems (including CentOS, RHEL, Ubuntu), it’s located at:
```
/etc/docker/daemon.json
```
### Allow an Insecure Registry
If you're running a local or self-hosted Docker registry without HTTPS, you need to add it as an "insecure registry" in this file:
```
{
  "insecure-registries" : ["myregistrydomain.com:5000"]
}
```
Or if you’re running it on localhost:
```
{
  "insecure-registries" : ["localhost:5000"]
}
```
### Restart Docker
Once you edit daemon.json, restart the Docker service:
```
sudo systemctl restart docker
```
Make sure there are no syntax errors in the JSON file, or Docker won’t start!

## Private Registry

### Push Images to Private Registry
To push images to your private registry, you first need to tag them with the address of your registry.

**1. Tag an Image:**
Suppose you have an image called myapp:latest that you want to push to the registry. You would tag it like this:
```
docker tag myapp:latest localhost:5000/myapp:latest
```
**2. Push the Image to the Registry:**
Once tagged, you can push the image to your registry:
```
docker push localhost:5000/myapp:latest
```
This command pushes the myapp:latest image to your private registry running on host localhost and port 5000.

### Pull Images from Private Registry
To pull an image from your private registry, use the docker pull command with the appropriate tag. For example:
```
docker pull localhost:5000/myapp:latest
```

## Conclusion
You’ve now set up your own private Docker registry server! This can be useful for managing custom Docker images within your organization or for deploying specific containers to your environments.

If you want to explore more advanced registry configurations or need SSL and authentication setups, Docker’s official registry documentation is a great resource: [Docker Registry Docs](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/).

Let me know if you need help with anything else!
