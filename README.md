## DockerBase Client Tool


This repository contains **Dockerbase** of **dockerbase** - a client tool to bootstrap/start/stop/destroy dockerbase contrainer.


### Installation - TODO

    curl -L github.com/dockerbase/dockerbase/install.sh | sh

### Usage

    bootstrap:
        sudo ./dockerbase bootstrap [service]

    start:
        sudo ./dockerbase start [service]

    stop:
        sudo ./dockerbase stop [service]

### Available services

    jenkins
    tomcat8

### Example

    $ sudo ./dockerbase bootstrap jenkins
