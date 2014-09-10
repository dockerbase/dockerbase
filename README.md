## DockerBase Client Tool


This repository contains **Dockerbase** of **dockerbase** - a client tool to pull/run/start/stop/destroy services.


### Installation

    curl -L github.com/dockerbase/dockerbase/install.sh | sh

### Usage

    sudo dockerbase pull [service]

    run:
        sudo dockerbase run [service]

    start:
        sudo dockerbase start [service]

    stop:
        sudo dockerbase stop [service]

### Example

    $ ./dockerbase run jenkins node1
