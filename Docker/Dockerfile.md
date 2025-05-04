## Dockerfiles

A Dockerfile is a script that contains a set of instructions for building a Docker image. Docker images are lightweight, standalone, and executable packages that include everything needed to run a piece of software, including the code, runtime, libraries, and system tools. Dockerfiles are used to automate the process of creating Docker images.

Here's a basic example of a Dockerfile:
```
# Use an official base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Copy application code into the container
COPY . .

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean

# Expose a port
EXPOSE 8080

# Define the command to run the application
CMD ["python3", "app.py"]
```
Now, let's break down each part of this Dockerfile:
1. **FROM:** Specifies the base image. In this case, it's Ubuntu 20.04.
2. **WORKDIR:** Sets the working directory inside the container. Subsequent instructions will be executed from this directory.
3. **COPY:** Copies files from the host machine to the container. Here, it copies the content of the current directory (the "." represents the current directory) into the "/app" directory inside the container.
4. **RUN:** Executes commands during the image build process. In this example, it updates the package list, installs Python3, and cleans up the package cache.
5. **EXPOSE:** Informs Docker that the container will listen on the specified network ports at runtime. It doesn't actually publish the ports, but it is a helpful documentation for other developers.
6. **CMD:** Provides the default command to run when the container starts. It specifies the command to run our application (in this case, a Python script).

Now, let's move on to a multi-stage Dockerfile example. Multi-stage builds allow you to use multiple FROM statements in a single Dockerfile, resulting in a smaller and more efficient final image.

```
# Stage 1: Build stage
FROM node:14 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production stage
FROM nginx:1.21
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
In this example:

1. The first stage (build) uses the Node.js image to build a JavaScript/Node.js application. It copies the necessary files, installs dependencies, and runs the build process.
2. The second stage uses the smaller Nginx image and copies the output from the build stage into the appropriate directory. This results in a final image containing only the compiled application and the Nginx server.

This approach helps reduce the size of the final image by excluding unnecessary build dependencies from the production stage. The --from=build flag in the COPY command allows copying files from a specific build stage.

#### Command:
```
docker build -t image_name:tag .
```
**Usage:** Builds a Docker image from a Dockerfile in the current directory.
