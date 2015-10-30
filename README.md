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

### Start the cluster

First start the cluster itself, so in the project directory do the following:

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


## Current Issues and problems.

Currently DNS is not working and it is in the process of being debugged. Here is a run down of things found, and possible issues.

* The Google kube2sky image (gcr.io/google_containers/kube2sky:1.11) was failing
to communicate with the api. Returning 
```Failed to list *api.Endpoints: couldn't get version/kind; 
json parse error: invalid character '<' looking for beginning of value```. Building the image from kubernetes master removes this error, and I can only assume is now working ok. It reports connection to etcd and API.
* When replacing {{ pillar['dns_domain']}} in the YAML template there is trailing
dot, this looks odd to me, but I can only imagine it must be correct for it to
work in production?
* The docker.md instructions start an etcd image, on 127.0.0.1:4001, the rc for the dns also start an etcd image on the same ports, could these be conflicting?




