## Docker Setup

Docker is a powerful platform that enables developers to package applications and their dependencies into lightweight, portable containers. Whether you're building web apps, APIs, or microservices, Docker can simplify your workflow.

In this guide, we'll walk you through installing Docker on your system step-by-step.

### Docker Installation
**1. Add the Docker Repository**
```sh
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
```
 This command adds the Docker repository to your system, which allows you to install Docker from the official Docker repositories. This is required before you can install Docker packages using dnf.

**2. View Available Repositories**
```
dnf repolist -v
```
This command lists all enabled repositories with verbose output. You can verify if the Docker repository you just added is listed.

**3. Check Available Versions of Docker CE**
```
dnf list docker-ce --showduplicates | sort -r
```
This command lists all available versions of Docker CE (Community Edition), sorted in reverse order (newest version first). It helps you choose the version to install if you don't want the latest version.

**4.  Install Containerd**
```
dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.10-3.2.el7.x86_64.rpm
```
This installs the containerd package, a container runtime required by Docker. The specific version (1.2.10-3.2.el7) is being installed here because the version available in the official CentOS repositories might not be the correct one or the one you need for Docker to function properly.

**5. Install Docker CE**
```
dnf install docker-ce -y
```
This command installs Docker CE (Community Edition) automatically, with the -y flag to skip the confirmation prompt. It's the final step to get Docker up and running on your system.

```
dnf install docker-ce --nobest
```
This command installs the Docker CE package, but the --nobest flag tells dnf not to automatically install the latest version. This might be useful if you're experiencing issues with the newest version and need a more stable or compatible one.

### Security :
1. Disable firewalld Service
```
systemctl disable firewalld
```
2. stop selinux
check the current selinux status.
```
sestatus
```
Disable the selinux permanently by editing the line in file **/etc/selinux/config**.
```
 SELINUX=disabled
```
Reboot the server to check if the changes are done permanently and verify the changes.
```
sudo reboot
sestatus
getenforce
```

### Start Docker
1. Start Docker Service
```
systemctl start docker
```
2. Check Docker service status
```
systemctl status docker
```
3. Enable Docker service
```
systemctl enable --now docker
```

### Check version
After installing, run:
```
docker --version
```
You should see something like **Docker version 24.x.x, build abcdef**.

## Docker Simple commands :
1. Pull Docker Images:
```
docker pull alpine
```
2. Check Images in local machine
```
docker images
```
3. create a Container Using Pulled images
```
docker run -it --rm alpine /bin/sh
```

### Uninstall
**1. Uninstall Docker Engine:** To remove Docker from your system, run:
```
sudo apt-get purge docker-ce docker-ce-cli containerd.io
```
**2. Remove All Docker-related Files:** If you want to delete Docker’s images, containers, volumes, and configuration files, run the following:
```
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```
**3. Uninstall Docker Compose:** If Docker Compose was installed vr as a standalone binary, use the following commands to remove it:
```
sudo rm /usr/local/bin/docker-compose
```
**4. Clean up Unused Dependencies:** You can remove any unused dependencies that were installed along with Docker:
```
sudo apt-get autoremove
```
**5. Restart Your Machine:** To ensure the complete removal of Docker and its components, restart your computer.
</br></br></br>
Let me know if you need help with anything else related to Docker!
