# Podman Course

## Important things 

1. Is not recommed to use the flag --name, because it can cause conflicts with other containers.Is only recommend to use when you dont have a lot of containers running.

## Introduction 

1. Podman is a daemonless container engine for developing, managing, and running OCI Containers on your Linux System.
2. Podman is rootless by default, which means that it does not require root privileges to run.

## Container Registries

We can change the default registry to our own registry. Normally, we have 
the registries configfile in `/etc/containers/registries.conf`. But we can make our own registries


```bash
# Create a custom registries.conf file 
mdkir ~/.config/containers 
touch ~/.config/containers/registries.conf
```

Inside of this file we can put our own container registries like our enterprise registries or custom 

```bash
# Like this if you need more information https://podman-desktop.io/docs/containers/registries
unqualified-search-registries = ["docker.io","ghrc.io", "quay.io"]
```

## Basic commands 

```bash
podman search <image_name> 
```

```bash
# You can download a image for a registrie
podman pull <image_name>
```

```bash
# List all the images you are downloaded
podman images
```

```bash
# You can run or create a container
podman  run --it <image_name>
# with --it flag you can run a virtual temrmial session within the container alllow you to interact with the container
#  with --rm flag you can remove the container when you exit
```

```bash
# List all the running containers
podman ps 
# with -a flag you can list all the containers, including the ones that are not running
```

```bash
podman run --name <container_name> -p ext_port:int_port <container_name>
# with --name flag you can give a name to the container
# with -p flag you define the port mapping between the external(your machine) port and the internal(container) port
```

```bash
# Start a one or more containers 
podman start <container_name>
```

```bash
# Stop a container
podman stop <container_name>
```

```bash
# Low level information on containers and images identified by their ID or name
podman inspect <container_name>
```
```bash
# Remove a container
podman rm <container_name>
```

```bash
# List the port mapping for a container
podman port <container_name>
```

```bash
# Remove the container image
podman rmi <container_name>
```
 ## Building a container image

 1. Firt thing you need to do is create a Dockerfile.
 2. Follow the next commands to build the image:
```bash
# Build the image from the dockerfile specified in the current directory with .(dot)
podman build -t <image_name> .
# with -t flag you can give a name to the image
# with . flag you specify the path to the Dockerfile
```
```bash
# Run the container from the image you just built
podman run --name <container_name> -p 8080:8080 <image_name>:<tag>
# with :<tag> flag you can specify the tag of the image to use
```

## Sharing a container image 

In this case we need to publish the image in a container registry so that others can use it.

```bash 
# autheticate with the registry where you want to publish the image
podman login <registry_name> 
# registry_name is the name of the registry you want to use
```

```bash
# build the image from the Dockerfile in the current directory
podman build -t <registry_username>/<image_name> .
```

```bash
podman push <username>/<container_name>
```

## Building pod with podman 

A pod provided a way for applications to be organized and scaled within Kubernetes cluster. More simple pods are a group of containers that are managed as a single unit and they share the same network, PID, and namespaces.
When  we create an empty pod, podman automatically adds an ``infra`` container. This container serves the purpose of holding the namespace associateed with the pod and allow podman connect other containers to the pod. The default pod container is based in ``k82.gcr.io`` all pods use this image for default
```bash
# list all podman pods options to use when we want work with pods 
podman pod --help
```

```bash
# create a pod with the specified name
podman pod create --name <pod_name>
```


```bash
# list all podman pods
podman pod ls
```

```bash
# list all containers in the pod
podman ps -a --pod
```

## Working with containers inside a pod with podman

We add a new container to the pod, in this case we add pdm-golang container

```bash
# enable run a new container image inside an existing pod 
podman run -dt --pod <pod_name> <container_image_name> 

# variant 
# create a new pod and run a container inside it
podman run -dt --pod new:<pod_name> <container_image_name>
```

```bash 
# this start a pod, be careful using podman start because this only works with container not with pods
podman pod start <pod_name>
```
```bash

# this stop a pod, be careful using podman stop because this only works with container not with pods
podman pod stop <pod_name> 
```
```bash
# before delete a pod we need to stoped
podman pod rm <pod_name>
```
## Working with K8s YAML manifest

With podman we can generate the kubernetes YAML manifest from the podman pods that can save developers a lot of time
#### Kubernetes file

Is essentially a file that contains instructions for kubernetes on how to create and managment  things such as pods, deployment, services and ConfigMaps in a kubernetes cluster.
The manifest file contains important details such as which container image to use, envoroment variables, volumes, and how things are related to each other in the cluster


```bash 
podman generate kube <pod_name>
```

```bash
podman generate kube <pod_name> >> {file_name}.yaml
```

```bash 
# this play a kubernetes manifest file, with this you can test your manifest file before deploying it to a kubernetes cluster
# this create a new pod based on the manifest file provided and you can test the functionality of the pod.
podman play kube  <file_name>.yaml
```
