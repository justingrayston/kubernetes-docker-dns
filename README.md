# kubernetes-docker-dns
Run a single kubernetes cluster, with DNS using docker for local development. 
The aim is to have an easy and consistant way of developing apps in the 
same environment they will be deployed into.

Currently using Mac OSX.

## Set up and run

There are some shell scripts to get you up and running. You will need to have your docker
environment set up first. Go get the [Docker Toolbox] (https://www.docker.com/docker-toolbox)
if you don't already have it.

You will also need kubectl, I have it installed via gcloud, but probably the easiest alternative
to that is via Homebrew on a Mac. 

```bash
$ brew install kubernetes-cli
```

You should now be ready to run a few scripts to get the cluster up and running.

### Update config and set up

First, update the values in config.sh if you need to. Please note that KUBE_SERVER
refers to the location of your K8s master, this serves as your API endpoint. This
will usually be your host IP. On Mac OSX, this will be the docker machine host
IP. Also if you are running this with a firewall on your network, make sure traffic
can actually reach the KUBE_SERVER.

Then run ```setup_dns.sh```, which will generate your replication controller and service yamls for DNS from the yaml templates.

### Start the cluster

Now start the cluster itself, so in the project directory do the following:

```bash
$ ./start_cluster.sh
```

This brings up an etcd instance and the k8s master and service proxy images. It is just a script for
running the docker commands outlined in the [docker.md](https://github.com/kubernetes/kubernetes/blob/master/docs/getting-started-guides/docker.md) on the Kubernetes repo.

If you use Kitematic, you should see the instances start. There maybe a wait on the first
run as it pulls the images onto the node. Alternatively use ```docker ps ```.

### Forward 8080 for k8s API

Now you have a k8s node running. Now to make things easier forward port 8080 over to your
local machine so you can use kubectl with out passing in -s.

```bash
$ ./port_forward.sh
```

This does it slightly differently to the instructions on the docker.md page, because for me
the docker-machine cmd suggested doesn't work. You should only need to do this once per VM start.


### Start k8s DNS

This will start the DNS replication controller and service. The configuration for these is in the dns/ directory, you
will find the yaml files there, should you wish to change number of replicas etc.

```bash
$ ./start_dns.sh
```

You will then see some more instances start up once the images are ready. You are now able to add your own rc, svc etc
for you application.

## Available .sh scripts

* start_cluster.sh - does what it says.
* port_forward.sh - forwards 8080 on the Docker VM over to local machine localhost:8080 (uses default machine),
this will be an arg at some point.
* start_dns.sh - starts the dns rc and svc
* remove_dns.sh - deletes the dns rc and svc (useful when debugging)
* stop_remove.sh - stops and removes all docker images (use with caution, it will remove all, not just the ones
started by the scripts, so if you have other images you may not want to use this.)






