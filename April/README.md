# Docker

## Get started with Docker

### **Part1: Orientation**

- check docker version  
    **`docker --version`**
    
    ```
    Docker version 18.09.2, build 6247962
    ```

- get more imformation about current version  
    **`docker info / docker version`**

    ```
    Client: Docker Engine - Community
    Version:           18.09.2
    API version:       1.39
    Go version:        go1.10.8
    Git commit:        6247962
    Built:             Sun Feb 10 04:12:31 2019
    OS/Arch:           windows/amd64
    Experimental:      false
    ```
    
- test docker installation  
    **`docker run hello-world`**

    ```
    Unable to find image 'hello-world:latest' locally
    latest: Pulling from library/hello-world
    1b930d010525: Pull complete
    Digest: sha256:2557e3c07ed1e38f26e389462d03ed943586f744621577a99efb77324b0fe535
    Status: Downloaded newer image for hello-world:latest

    Hello from Docker!
    This message shows that your installation appears to be working correctly.

    To generate this message, Docker took the following steps:
    1. The Docker client contacted the Docker daemon.
    2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
        (amd64)
    3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
    4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.

    To try something more ambitious, you can run an Ubuntu container with:
    $ docker run -it ubuntu bash

    Share images, automate workflows, and more with a free Docker ID:
    https://hub.docker.com/

    For more examples and ideas, visit:
    https://docs.docker.com/get-started/
    ```

- list docker images  
    **`docker image ls`**
    ```
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    hello-world         latest              fce289e99eb9        2 months ago        1.84kB
    ```

- list containers  
    **`docker container ls (-a/-all for all containers including stopped)`**  
    ```
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                         PORTS               NAMES
    11a68cfa5d90        hello-world         "/hello"            About an hour ago   Exited (0) About an hour ago                       youthful_heisenberg
    ```

#### recap and cheat sheet

    ```
    list docker commands 
        docker 
        docker container --help

    show docker version and info
        docker --version
        docker version
        docker info
        
    execute docker image 
        docker run hello-world

    list docker images
        docker image ls

    list docker containers (running,all,all and quiet)
        docker container ls
        docker container ls (-a/-all) 
        docker container ks -aq
    ```