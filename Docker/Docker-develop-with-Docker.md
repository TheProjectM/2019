# **Develop with Docker**

This page lists resources for application developers using Docker.

## **Develop your apps on Docker**

If you are just getting started developing a brand new app on Docker, check out these resources to understand some of the most common patterns for getting the most benefits from Docker.
-   Learn to [build an image from a Dockerfile](https://docs.docker.com/get-started/part2/)
-   Use [multistage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) to keep your image lean
-   Manage application data using [volumes](https://docs.docker.com/engine/admin/volumes/volumes/) and [bind mounts](https://docs.docker.com/engine/admin/volumes/bind-mounts/)
-  [ Scale your app](https://docs.docker.com/get-started/part3/) as a swarm service
-   [Define your app stack](https://docs.docker.com/get-started/part5/) using a compose file
-   General application development best practices

### **Learn about language-specific app development with Docker**
-   [Docker for java developers](https://github.com/docker/labs/tree/master/developer-tools/java/) lab
-   [Port a node.js app to Docker](https://github.com/docker/labs/tree/master/developer-tools/nodejs/porting)
-   [Ruby on Rails app on Docker](https://github.com/docker/labs/tree/master/developer-tools/ruby) lab
-   [Dockerize a .Net Core application](https://docs.docker.com/engine/examples/dotnetcore/)
-   [Dockerize an ASP.NET Core application with SQL Server on Linux](https://docs.docker.com/compose/aspnet-mssql-compose/) using Docker Compose

### **Advanced development with the SDK or API**

After you can write Dockerfiles or Compose files and use Docker CLI, take it to the next level by using Docker Engine SDK for Go/Python or use the HTTP API directly.

## **Docker development best practices**

The following development patterns have proven to be helpful for people building applications with Docker.

### **How to keep your images small**

Small images are faster to pull over the network and faster to load into memory when starting containers or services.
There are a few rules of thumb to keep image size small:
-   Start with an appropriate base image.For instance, if you need a JDK, consider basing your image on the official `openjdk` image, rather than starting with a generic `ubuntu` image and installing `openjdk` as part of the Dockerfile.
-   Use multistage builds. For instance, you can use the `maven` image to build your java application, then reset to the `tomcat` image and copy the Java artifacts into the correct location to deploy your app, all in the same Dockerfile. This means that your final image does not include all of the libraries and dependencies pulled in by the build, but only the artifacts and the environment needed to run them.
    -   If you need to use a version of Docker that does not include multistage builds, try to reduce the number of layers in your image by minimizing the number of separate `RUN` commands in you Dockerfile. You can do this by consolidating multiple commands into a single `RUN` line and using your shell's mechanisms to combine them together. Consider the following two fragments. The first creates two layers in the image, while the second only creates one.
        ```
        RUN apt-get -y update
        Run apt-get install -y python
        ```
        ```
        Run apt-get install -y update && apt-get install -y python
        ```
        
    -   If you have multiple images with a lot in common, consider creating your own base image with the shared components, and basing your unique images on that. Docker only needs to load the common layers once, and they are cached. This means that your derivative images use memory on the Docker host more efficiently and load more quickly.
    -   To keep your production image lean but allow for debugging, consider using the production image as the base image for the debug image. Additional testing or debugging tooling can be added on top of the production image.
    -   When building images, always tag them with useful tags which codify version information, intended destination(`prod` or `test`, for instance), stability, or other information that is useful when deploying the application in different environments. Do note rely on the automatically-created `latest` tag.
  
### **Where and how to persist application data**

-   **Avoid** storing application data in your container's writable layer using storage drivers. This increases the size of your container and is less efficient from an I/O perspective than using volumes or bind mounts.
-   Instead, store data using volumes.
-   One case where it is appropriate to use bind mounts is during development, when you may want to mount your source dictionary or a binary you just built into your container. For production, use a volume instead, mounting it into the same location as you mounted a bind mount during development.
-   For production, use secrets to store sensitive application data used by services, and use configs for non-sensitive data such as configuration files. If you currently use standalone containers, consider migrating to use single-replica services, so that you can take advantage of these service-only features.

### **Use swarm services when possible**
-   When possible, design your application with the ability to scale using swarm services.
-   Even if you only need to run a single instance of your application, swarm services provide several advantages over standalone containers. A service's configuration is declarative, and Docker is always working to keep the desired and actual state in sync.
-   Networks and volumes can be connected and disconnected from swarm services, and Docker handles redeploying the individual service containers in a non0disruptive way. Standalone containers need to be manually stopped, removed, and recreated to accommodate configuration changes.
-   Several features, such as the ability to store secrets and configs, are only available to services rather than standalone containers. These features allow you to keep your image as generic as possible and to avoid storing sensitive data within the Docker images or containers themselves.
-   Let `docker stack deploy` handle any image pills for you, instead of using `docker pull`. This way, your deployment does npt try to pull from nodes that are down. Also, when nodes are added to the swarm, images are pulled automatically.

There are limitations around sharing data amongst nodes of a swarm service. If you use Docker for AWS or Docker for Azure, you can use the Cloudstor plugin to share data amongst your swarm service nodes. You can also write your application data into a separate database which supports simultaneous updates.


### **Use CI/CD for testing and deployment**

-   When you check a change into source control or create a pull request, use Docker Hub or another CI/CD pipeline to automatically build and tag a Docker image and test it.
-   Take this even further with Docker EE by requiring your development, testing, and security teams to sign images before they can be deployed into production. This way, you can be sure that before an image is deployed into production, it has been tested and signed off by, for instance, development, quality, and security teams.

### **Difference in development and production environments**

| **Development**                                                    | **Production**                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Use bind mounts to give your container access to your source code. | Use volumes to store container data.                                                                                                                                                                                                             |
| User Docker Desktop for Mac or Docker Desktop for Windows.         | Use Docker EE if possible, with userns mapping for grater isolation of Docker processes from processes.                                                                                                                                          |
| Don not worry about time drift.                                    | Always run an NTP client on the Docker host and within each container process and sync them all to the same NTP server. If you use swarm services, also ensure that each Docker node syncs its clocks to the same time source as the containers. |


## **Develop images**

### **Best practices for writing Dockerfiles**

This document covers recommended best practices and methods for building efficient images.

Docker builds images automatically by reading the instructions from a `Dockerfile` -- a text file that contains all commands, in order, needed to build a given image. A `Dockerfile` adheres to a specific format and set of instructions which you can find at [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

A Docker image consists of read-only layers each of which represents a Dockerfile instruction. The layers are stacked and each one is a delta of the changes from the pervious layer.
Consider this `Dockerfile`:

    FROM ubuntu:18.04
    COPY . /app
    RUN make /app
    CMD python /app/app.py

Each instruction creates one layer:

-   `FROM` creates a layer from the `ubuntu:18.04` Docker image.
-   `COPY` adds file from your Docker client's current directory.
-   `RUN` builds your application with `make`.
-   `CMD` specifies what command to run within the container.

When you run an image and generate a container, you add a new writable layer(the "container layer") on top of the underlying layers. All changes made to the running container, such as writing new files, modifying existing files, and deleting files, are written to this thin writable container layer.

For more on image layers (and how Docker builds and stores image), see [About storage drivers](https://docs.docker.com/storage/storagedriver/).

#### **General guidelines and recommendations**

##### **Create ephemeral containers**

The image defined by your `Dockerfile` should generate containers that are as ephemeral as possible. By "ephemeral", we mean that the container can be stopped and destroyed, then rebuilt and replaced with an absolute minimum set up and configuration.

Refer to Process under **The Twelve-factor App** methodology to get a feel for the motivations of running containers in such a stateless fashion.

##### **Understand build context**

When you issue a `docker build` command, the current working directory is called the **build context**. By default, the Dockerfile is assumed to be located here, but you can specify a different location with the file flag `-f`. Regardless of where the `Dockerfile` actually lives, all recursive contents of files and directories in the current directory are sent to the Docker daemon as the build context.

> - [x] **Build context example**
> Create a dir for the build context and `cd` into it. Write "hello" into a text file named `hello` and create a Dockerfile that runs `cat` on it. Build the image from within the build context (`.`):
>   ```
>   mkdir myproject && cd myproject
>   echo "hello" > hello
>   echo -e "FROM busybox\nCOPY /hello /\nRUN cat /hello" > Dockerfile
>   docker build -t helloapp:v1 .
>   ```
> Move `Dockerfile` and `hello` into separate dirs and build a second version of the image(without relaying on cache from the last build). Use `-f` to point to the Dockerfile and specify the dir of the build context:
>   ```
>   mkdir -p dockerfiles context
>   mv Dockerfile dockerfiles && mv hello context
>   docker build --no-cache -t helloapp:v2 -f dockerfiles/Dockerfile context
>

Inadvertently including files that are not necessary for building an image results in a larger build context and larger image size. This can increase the time to build the image, time to pull and push it, and the container runtime size. To see how big your build context is, look for a message like this when building your `Dockerfile`:

    Sending build context to Docker daemon 187.8MB

