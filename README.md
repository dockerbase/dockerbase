## DockerBase Client Tool


This repository contains **Dockerbase** of **dockerbase** - a client tool to bootstrap/start/stop/destroy dockerbase contrainer.


### Installation

    curl -L https://raw.github.com/dockerbase/dockerbase/master/install.sh | sh

### Usage at ~/.dockerbase

    bootstrap:
        sudo ./dockerbase bootstrap [service]

    start:
        sudo ./dockerbase start [service]

    stop:
        sudo ./dockerbase stop [service]

### Available services

    jenkins
    tomcat8
    nginx

### Example

    $ sudo ./dockerbase bootstrap jenkins
