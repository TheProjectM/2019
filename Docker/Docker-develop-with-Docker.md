# **Develop with Docker**

This page lists resources for application developers using Docker.

**Develop new apps on Docker**

If you are just getting started developing a brand new app on Docker, check out these resources to understand some of the most common patterns for getting the most benefits from Docker.
-   Learn to [build an image from a Dockerfile](https://docs.docker.com/get-started/part2/)
-   Use [multistage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) to keep your image lean
-   Manage application data using [volumes](https://docs.docker.com/engine/admin/volumes/volumes/) and [bind mounts](https://docs.docker.com/engine/admin/volumes/bind-mounts/)
-  [ Scale your app](https://docs.docker.com/get-started/part3/) as a swarm service
-   [Define your app stack](https://docs.docker.com/get-started/part5/) using a compose file
-   General application development best practices

**Learn about language-specific app development with Docker**
-   [Docker for java developers](https://github.com/docker/labs/tree/master/developer-tools/java/) lab
-   [Port a node.js app to Docker](https://github.com/docker/labs/tree/master/developer-tools/nodejs/porting)
-   [Ruby on Rails app on Docker](https://github.com/docker/labs/tree/master/developer-tools/ruby) lab
-   [Dockerize a .Net Core application](https://docs.docker.com/engine/examples/dotnetcore/)
-   [Dockerize an ASP.NET Core application with SQL Server on Linux](https://docs.docker.com/compose/aspnet-mssql-compose/) using Docker Compose

**Advanced development with the SDK or API**

After you can write Dockerfiles or Compose files and use Docker CLI, take it to the next level by using Docker Engine SDK for Go/Python or use the HTTP API directly.

## **Docker development best practices**

The following development patterns have proven to be helpful for people building applications with Docker.

**How to keep your images small**

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
  
**Where and how to persist application data**

-   **Avoid** storing application data in your container's writable layer using storage drivers. This increases the size of your container and is less efficient from an I/O perspective than using volumes or bind mounts.
-   Instead, store data using volumes.
-   One case where it is appropriate to use bind mounts is during development, when you may want to mount your source dictionary or a binary you just built into your container. For production, use a volume instead, mounting it into the same location as you mounted a bind mount during development.
-   For production, use secrets to store sensitive application data used by services, and use configs for non-sensitive data such as configuration files. If you currently use standalone containers, consider migrating to use single-replica services, so that you can take advantage of these service-only features.

**Use swarm services when possible**
-   When possible, design your application with the ability to scale using swarm services.
-   Even if you only need to run a single instance of your application, swarm services provide several advantages over standalone containers. A service's configuration is declarative, and Docker is always working to keep the desired and actual state in sync.
-   Networks and volumes can be connected and disconnected from swarm services, and Docker handles redeploying the individual service containers in a non0disruptive way. Standalone containers need to be manually stopped, removed, and recreated to accommodate configuration changes.
-   Several features, such as the ability to store secrets and configs, are only available to services rather than standalone containers. These features allow you to keep your image as generic as possible and to avoid storing sensitive data within the Docker images or containers themselves.
-   Let `docker stack deploy` handle any image pills for you, instead of using `docker pull`. This way, your deployment does npt try to pull from nodes that are down. Also, when nodes are added to the swarm, images are pulled automatically.

There are limitations around sharing data amongst nodes of a swarm service. If you use Docker for AWS or Docker for Azure, you can use the Cloudstor plugin to share data amongst your swarm service nodes. You can also write your application data into a separate database which supports simultaneous updates.