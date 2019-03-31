# **Docker**

## **Get started with Docker**

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

### **Part2: Containers**

For Flask demo
1. define a contatiner with `Dockerfile`
2. create the `requirements.txt`
3. create `app.py`
4. build the app at the top level of the new directory `docker build --tag=friendlyhello`
5. then you can list the docker image with `docker image ls`
6. run the app using `docker run -p 4000:80 friendlyhello` -p for port mapping.
7. run the app in the background, in the detached mode with `-d` option.`docker run -d -p 4000:80 friendlyhello`
8. use `docker container ls` to list the running containers.
9. stop docker container using `docker container stop <CONTAINER ID>`

Share image
1. You will need a Docker account, sign up one at [hub.docker.com](https://hub.docker.com/)
2. Login docker with `docker login` and code in the username and password.
3. Tag the image: the syntax of the command is `docker tag image username/repository:tag`, this step is just for associating the local image with a repository on a registry, after the previous command is done, you can use the `docker image ls` command to see the newly tagged image `username/repository  tag`
4. Publish the image: upload the tagged image to the repository, the syntax is `docker push username/repository:tag`. Once complete, the results of this upload are publicly available.
5. Pull and run the image from remote repository: now you can run your app using `docker run -p 4000:80 username/repository:tag`.
6. no matter where docker run executes, it pulls your image. along with Python and all the dependencies from `requirements.txt`, and run your code. it all travels together in a neat little package, and you don't need to install anything on the host machine for Docker to run it.

#### Recap and cheat sheet

[Here is the terminal recording of what was covered on this page](https://asciinema.org/a/blkah0l4ds33tbe06y4vkme6g)

Here is a list of basic Docker commands from part2, and some related ones if you would like to explore a bit before moving on.

    docker build -t friendlyhello .      # create image using this dir's Dockerfile
    docker run -p 4000:80 friendlyhello      # run "friendlyhello" mapping port 4000 to 80
    docker run -d -p 4000:80 friendlyhello      # the same as above but in detached mode
    docker container ls    # list all running containers
    docker container ls -a      # list all containers, even the host not running
    docker container stop <hash>    # gracefully stop the specified container
    docker container kill <hash>    # force shutdown the specified container
    docker container rm <hash>      # remove specified container from this machine
    docker container rm $(docker container ls -a -q)    # remove all containers
    docker image ls -a      # list all images on this machine
    docker image rm <image id>      # remove specified image from this machine
    docker image rm $(docker image ls -a -q)    # remove all images from this machine
    docker login    # log in hub.docker.com with your username and password
    docker tag <image> username/repository:tag      # tag <image> for upload to registry
    docker push username/repository:tag     # upload tagged image to username/repository:tag
    docker run username/repository:tag     # run image from a registory

### **Part3: Services**

#### Introduction

In this part, we scale application and enable load-balancing. To do this, we need to go one level up in the hierarchy of a distributed application: the service.

#### About services

In a distributed application, different pieces of the app are called "services".  
Services are really just "containers in production". A service only run one image.  
It's easy to define, run, and scale services with the Docker platform -- just write a `docker-compose.yml` file.

#### Your first `docker-compose.yml` file

A `docker-compose.yml` file is a YAML file that defines how Docker containers should beheave in produciton.

**`docker-compose.yml`**

```
version: "3"
services:
  web:
    image: srealzhang/aiixm:part2
    deploy:
      replicas: 5
      resources: 
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "4000:80"
    networks:
      - webnet
networks:
  webnet:
```

#### Run your new load-balalce app

Before we can use the `docker stack deploy` command we first run:

    docker swarm init

Now run it with the name `getstartedlab`. One Single service stack is running 5 containers of our deployed image on one host.

    docker stack deploy -c docker-compost.yml getstartedlab
    


Get the service ID for the one service in the application.

    docker service ls

Alternatively, for `docker service ls` is `docker stack services <stack_name>` 

    docker stack services getstartedlab

A single container running in a service is called a **task**. Task are given unique IDs that numerically increment, up to the number of `replicas` you defined in docker-compose.yml, list the tasks of your service using `docker service ps <service_name>`:

    docker service ps getstartedlab_web

Tasks also show up if you just list all the containers on your system, though that is not filtered by service:

    docker container ls -q

Now the app is running in the load-balanced mode with 5 containers. every time you visit `http://localhost:4000` you will get a different hostname against the pervious one.

To view all tasks of a stack, you can run `docker stack ps <stack_name/app_name>

    docker stack ps getstartedlab

#### Scale the app

You can scale the app by changing the `replicas` value in docker-compose.yml, saving the change, and re-running the `docker stack deploy` command :

    docker stack deploy -c docker-compose.yml getstartedlab

Docker performs an in-place update, no need to tear down first or kill any containers.

#### Tear down the app and the swarm

- Take the app down with `docker stack rm`:
  
        docker stack rm getstartedlab

- Take down the swarm:
  
        docker swarm leave --force 

It's as easy as that to stand up and scale your app with Docker.

#### Recap and cheat sheet
[Here's a terminal recording of what was covered on part3: Services](https://asciinema.org/a/b5gai4rnflh7r0kie01fx6lip)

To recap, typing `docker run` is simple enough, the true implementation of a container in production is running it as a service. Services codify a container's beheavior in a Compose file, and this file can be used to scale, limit, and redeploy our app, Changes to the service can be applied in place, as it runs, using the same command that launched the service:

Some commands to explore at this stage:

    docker stack ls     # list stacks or apps
    docker stack deploy -c <composefile> <appname>      # run the specified Compose file
    docker service ls     # list runnings services associated with an app
    docker servics ps <service>     # list tasks associated with an app
    docker inspect <task or container>      # inspect task or container
    docker container ls -q      # list container IDs
    docker stack rm <stackname or appname>      # Tear down an appliation
    docker swarm leave --force     # Tear down a single node swarm from the manager.
