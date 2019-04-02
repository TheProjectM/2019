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


### **Part4: Swarm**

#### Introduction

In part3, you took an app you wrote in part2, and defined how it should run in produciton by turning it into a service, scaling it up to 5x in the process.

Here in part4, you deploy this application onto a cluster, running it on multiple machines.Multi-container, multi-machine applications are made possible by joining multiple machines into a "Dockerized" cluster called a **swarm**.

#### Understanding Swarm clusters

A swarm is a group of machines that are running Docker and joined into a cluster. After that has happened, you continue to run the Docker commands you're used to, but how they are executed on a cluster by a **swarm manager**. The machines in a swarm can be physical or virtual. After joining a swarm, they are reffered to as **nodes**.

Swram managers can use sereval strategies to run containers, such as "emptiest node" --which fills the least utilized machines with containers.
Or "global", which ensures that each machine gets exactly one instance of the specified container. You instruct the swarm manager to use these strategies in the Compose file, just like the one you have already been using.

Swarm manageers are the only machines in a swarm that can execute your commands, or authorize other machines to join the swarm as **workers**.
Workers are just there to provide capacity and do not have the authority to tell any other machine what it can and cannot do.

Up until now, you have been using Docker in s single-host mode on your local machine. But Docker also cdan be switched into **swarm mode**, and that is what enables the use of swarms. Enabling swarm mode instantly makes the current machine a swarm manager. From then on, Docker runs the commnads you execute on the swarm you are managing, rather than just on the current machine.

#### Set up your swarm

A swarm is made up of multiple nodes, which can be physical and virtual machines. The basic concept is simple enough: run `docker swarm init` to enable swarm mode and make your currnet machine a swarm manager, then run `docker swarm join` on other machines to have them join the swarm as workers. 

**Create a cluster**

Create local virtual machine using Hyper-V on Windows 10:

1. Launch Hyter-V Manager
2. Click **Virtual Switch Manager** in the right-hand menu
3. Click **Create Virtual Switch** of type External
4. Give it the name `myswitch`, and check the box to share your host machine's active network adapter

now create a couple of VMs using our node management tool, `docker-machine`

    docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1
    docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm2

**List the VMs and get their ip addresses**

Now we have two VMs created, named `myvm1` and `myvm2`

    docker-machine ls

here is an example output from my terminal

```
NAME    ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER     ERRORS
myvm1   -        hyperv   Running   tcp://192.168.1.218:2376           v18.09.3
myvm2   -        hyperv   Running   tcp://192.168.1.219:2376           v18.09.3
```

**Initialize the searm and add nodes**

The first machine acts as the manager, which executes management commands and authenciates workers to join the swarm, and the second is a worker.

You can send commands to your VMs using `docker-machine ssh`. instruct myvm1 to become a swarm manager with `docker swarm init` and the output should like this"

    $ docker-machine ssh myvm1 "docker swarm init --advertise-addr 192.168.1.218"

    Swarm initialized: current node (b8ukc9tbkjwgl4g9c00ok5brk) is now a manager.
    To add a worker to this swarm, run the following command:
    docker swarm join --token <token> 192.168.1.218:2377
    To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.


> Port 2377 and 2376 :  
> 2377 is the default port, you can run `docker swarm init` and `docker swarm join` command through 2377  
> 2376 port returned by command `docker-machine ls` is the Docker daemon port.

> When having trouble using ssh command, try to use `--native-ssh` flag  
> `docker-machine --native-ssh ssh myvm1 ...`

As you can see, the response to docker swarm init cantains a pre-configured `docker swarm join` command for you to run on any nodes you want to add. Copy this command, and send it to `myvm2` via `docker-machine ssh` to have `myvm2` join your new swarm as a worker: 

    $ docker swarm join --token <token> 192.168.1.218:2377

    This node joined a swarm as a worker.

Congratulations, you have created your first swarm!
Run `docker node ls` on the manager to view the nodes in this swarm:

    $ docker-machine ssh myvm1 "docker node ls"

    ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
    xhnj4d1fxlntazp9h6a1e4nn7 *   myvm1               Ready               Active              Leader              18.09.3
    3nw87xb2sjtyi1p9b2mkb1ofo     myvm2               Ready               Active                                  18.09.3

> Remember to use `docker swarm leave` command to leave the swarm for the worker machine, for the last manager machine add `--force` to leave the swarm.

**Deploy your app on the swarm clustre**

The hard part is over. Only swarm manager like `myvm1` execute Docker commands, workers are just for capacity.

**Configure a `docker-machine` shell to the swarm manager**

run **docker-machine env myvm1** command and you will get the result below on Windows 10 :

    $ docker-machine env myvm1

    # Run this command to configure your shell:
    # & "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression

and then run the **& "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression**

    $ & "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression
    
Run `docker-machine ls` to make sure that `myvm1` is the active machine as indicated by the asterisk `*` next to it.

    $ docker-machine ls 
    NAME    ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER     ERRORS
    myvm1   *        hyperv   Running   tcp://192.168.1.218:2376           v18.09.3
    myvm2   -        hyperv   Running   tcp://192.168.1.219:2376           v18.09.3

**Deploy the app on the warm manager**

Just run `docker stack deploy -c docker-compose.yml getstartedlab` as a normal machine, **it will take a few seconds for the service fully started**, and use command `docker stack ps getstartedlab` to check the service status.

    $ docker stack deploy -c docker-compose.yml getstartedlab

    Creating network getstartedlab_webnet
    Creating service getstartedlab_web

    $ docker stack ps getstartedlab

    ID                  NAME                  IMAGE                    NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
    ephrkk1su4mg        getstartedlab_web.1   username/repository:tag   myvm2               Running             Running 14 minutes ago
    nr9i2tphazoq        getstartedlab_web.2   username/repository:tag   myvm1               Running             Running 13 minutes ago
    v3kppovrwkzb        getstartedlab_web.3   username/repository:tag   myvm2               Running             Running 12 minutes ago
    4ix8t7p4ch8p        getstartedlab_web.4   username/repository:tag   myvm1               Running             Running 12 minutes ago
    96o17pft149n        getstartedlab_web.5   username/repository:tag   myvm2               Running             Running 12 minutes ago

> we can use `docker-machine ssh` and `docker-machine env` to send commands to the VMs. `docker-machine ssh` is more like a one-touch mode; whereas `docker-machine env` is more like a interactive mode. because the later one is link the currnet shell to the VM's Docker daemon.  
>so the next question is how to determine "where are you in?". It can be addressed using command `docker-machine ls` in the **ACTIVE** column, the `*` shows where you are. if all the column are `-`, then you are not in any VMs.

**Accessing your cluster**

You can access your app from the IP address of either `myvm1` or `myvm2`.

The network you created is shared between then and load-balancing. Run `docker-machine ls` to get your VMs' IP addresses and visit either of them on a browser, hitting refresh you will get all the containers IDs with a load-balancing cycling.

**Ingress routing mesh network explain**
<img src="https://github.com/TheProjectM/2019/blob/master/Docker/imgs/ingress-routing-mesh.png">


**Iterating and scaling your app**

From here you can do everything you learned about in part2 and part3.

Scale the app by changing the `docker-compose.yml` file

You can join any mahine, physical and virtual, to this swarm, using the same `docker swarm join` command you used on `myvm2`, and capacity is added to your cluster. Just run `docker stack deploy` afterwards, and your app can take advantage of the new resources.

#### Cleanup and reboot

**Stacks and swarms**

You can tear down the stack with `docker stack rm`. for example:

    docker stack rm getstartedlab

As for swarms in the VMs, you can use `docker swarm leave` for workers and `docker swarm leave --force` for the last manager.

**Unsetting docker-machine shell varibale settings**

You can unset the `docker-machine` environment variables in your current shell with the given command.

On **Mac or Linux** the command is :

    docker-machine env -u

On **Windows** the command is :

    & "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env -u | Invoke-Expression
    
when you run `docker-machine env -u` command on windows, you will get the above command at the end of the result.

**Restarting Dcoker machines**

You can stop the docker machine using command `docker-machine stop <machine-name>`

    docker-machine stop myvm1
    docker-machine stop myvm2

use command `docker-machine ls` to check the Docker created VMs status:

    $ docker-machine ls

    NAME    ACTIVE   DRIVER   STATE     URL   SWARM   DOCKER    ERRORS
    myvm1   -        hyperv   Stopped                 Unknown
    myvm2   -        hyperv   Stopped                 Unknown

To restart a machine that's stopped, run:

    docker-machine start <machine-name>


#### Recap and cheat sheet
[Here is the terminal recording of what was covered on this part.](https://asciinema.org/a/113837)

In part4 you learned what a swarm is, how nodes in swarms can be managers or workers, created a swarm, and deployed an applocation on it. You saw that core Docker commands didn't change from part 3, they just had to be targeted to run on a swarm master. You also saw the power of Docker's networking in action, which kept load-balancing requests across containers, even though they were running on different machines. Finally, you learned how to iterate and scale your app on a cluster.

Here are some commands you might like to run to interact with your swarm and your VMs a bit:

    docker-machine create --driver virtualbox myvm1     # create a VM (Mac,Win7, Linux)
    docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1    # Win10
    docker-machine env myvm1    # view basick information about node
    docker-machine ssh myvm1 "docker node ls"       # inspect a node
    docker-machine ssh myvm1 "docker node inspect <node ID>
    docker-machine ssh myvm1 "docker swarm join-token -q worker"    #view join token
    docker-machine ssh myvm1    # open a ssh session with the VM; type "exit" to end
    docker node ls      # view nodes in swarm (while logged on to manager)
    docker-machine ssh myvm2 "docker swarm leave"   # make the worker leave the swarm
    docker-machine ssh myvm1 "docker swarm leave --force/-f"   # make the master leave the swarm and kill the swarm.
    docker-machine ls   # list VMs, asterisk shows which VM this shell is talking to 
    docker-machine start myvm1      # start a VM which is not running
    docker-machine env myvm1    # show environment variables and command for connecting to myvm1
    docker-machine env myvm1    # Linux and Mac command to connect shell to myvm1
    & "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression       # Windows command to connect shell to myvm1
    docker stack deploy -c <Compose-file> <app-name>    # deploy an app, command shell mast be set to talk to manager(myvm1), use local Compose file
    docker-machine scp docker-compose.yml myvm1:~   # copy file to node's home dir (only required if you use ssh to connect to manager and deploy app)
    docker-machine ssh myvm1 "docker stack deploy -c <Compose-file> <app-name>"     # Deploy an app using ssh (you must have first copied the Compose file to myvm1)
    docker-machine env -u/--unset       # disconnect shell from VMs, use native Docker
    docker-machine stop $(docker-machine ls -q)     # stop all running VMs
    docker-machine rm $(docker-machine ls -q)       # delete all VMs and their task images

### **Part5: Stacks**

**Introduction**

Here in part5, you reach the top of the hierarchy of distributed applications:
 the **stack**. A stack is a group of interrelated services that share dependencies, and can be orchestrated and scaled together. A single stack is capable of defining and coordinating the funcitonality of an entir application(though very complex applications may want to use multiple stacks)

 Some good news is, you have technically been working with stacks since part3, when you created a Compose file and used `docker stack deploy`. But that was a single service stack running on a single host, which is not usually what takes place in production. Here, you can take what you've learned, make multiple services relate to each other, and run them on multiple machines. 

**Add a new service and redeploy**

It's easy to add services to our `docker-compose.yml` file. First, let's add a free visualizer service that lets us look at how our swarm is scheduling containers.

1. Modify the `docker-compose.yml` file, add `visualizer` to the services.

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
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8000:8000"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks: 
      - webnet
networks:
  webnet:
```
The only thing new here is the peer service to `web`, named `visualizer`.Notice two new thins here: a `volumes` key, giving the visualizer access to the host's socket file for Docker, and a `placement` key, ensuring that this service only ever runs on a swarm manager -- never a worker. That's because this container, built from an open source project created by Docker, displays Docker services running on a swarm in a diagram.

2. Make sure your shell is configured to talk to `myvm1`
   - Run `docker-machine ls` to list machines and make sure you are connected to `myvm1`, as indicated by an asterisk next to it.
   - if needed, re-run `docker-machine env myvm1`, then run the given command to configure the shell.
     - On **Mac or Linux** the command is:
        ```
        $ docker-machine env myvm1
        ```
     - On **Windows** the command is:
        ```
        $ & "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression
        ```
3. Re-run the `docker stack deploy` command on the manager, and whatever services need updating are updated:
    ```
    $ docker stack deploy -c docker-compose.yml getstartedlab

    Updating service getstartedlab_web (id: tw44nisqvmhxrb05ntnxv5j23)
    Creating service getstartedlab_visualizer
    ```

4. Take a look at the visualizer.
<img src="https://github.com/TheProjectM/2019/blob/master/Docker/imgs/docker-visualizer.png">

