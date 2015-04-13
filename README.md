Owncloud Dockerfile
=============

This repository contains Dockerfile of Owncloud for Docker's automated build published to the public Docker Hub Registry.

# Base Docker Image
[dockerfile/supervisor](https://registry.hub.docker.com/u/dockerfile/supervisor/)

# Installation

## Install Docker.

Download automated build from public Docker Hub Registry: docker pull kdelfour/owncloud-docker:8.0.2

(alternatively, you can build an image from Dockerfile: docker build -t="kdelfour/owncloud-docker" github.com/kdelfour/owncloud-docker)

## Usage

    docker run -it -d -p 80:80 -p 443:443 kdelfour/owncloud-docker:8.0.2
    
You can add a shared directory as a volume directory with the argument *-v /your-path/data/:/data/* like this :

    docker run -it -d -p 80:80 -p 443:443 -v /your-path/data/:/data/ kdelfour/owncloud-docker:8.0.2

An embedded database is available.
    
## Build and run with custom config directory

Get the latest version from github

    git clone https://github.com/kdelfour/owncloud-docker
    cd owncloud-docker/

Build it

    sudo docker build --force-rm=true --tag="$USER/owncloud-docker:8.0.2" .
    
And run

    sudo docker run -d -p 80:80 -p 443:443 -v /your-path/data/:/data/ $USER/owncloud-docker:8.0.2
    
Enjoy !!    