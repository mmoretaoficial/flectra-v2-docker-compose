# Quick install

Installing Flectra v2 with one command.

(Supports multiple Flectra instances on one server)

Install [docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/) yourself, then run:

``` bash
curl -s https://github.com/mmoretaoficial/flectra-v2-docker-compose/master/run.sh | sudo bash -s flectra-one 10002 20002
```

to set up first Flectra instance @ `localhost:1002` (default master password: `flectra.info`)

and

``` bash
curl -s https://github.com/mmoretaoficial/flectra-v2-docker-compose/master/run.sh | sudo bash -s flectra-two 11002 21002
```

to set up another Flectra instance @ `localhost:11002` (default master password: `flectra.info`)

Some arguments:
* First argument (**flectra-one**): Flectra deploy folder
* Second argument (**10002**): Flectra port
* Third argument (**20002**): live chat port

If `curl` is not found, install it:

``` bash
$ sudo apt-get install curl
# or
$ sudo yum install curl
```

# Usage

Start the container:
``` sh
docker-compose up
```

* Then open `localhost:10002` to access Flectra v2.0. If you want to start the server with a different port, change **10002** to another value in **docker-compose.yml**:

```
ports:
 - "10002:7073"
```

Run Flectra container in detached mode (be able to close terminal without stopping Flectra):

```
docker-compose up -d
```

**If you get the permission issue**, change the folder permission to make sure that the container is able to access the directory:

``` sh
$ git clone https://github.com/mmoretaoficial/flectra-v2-docker-compose
$ sudo chmod -R 777 addons
$ sudo chmod -R 777 etc
$ mkdir -p postgresql
$ sudo chmod -R 777 postgresql
```

Increase maximum number of files watching from 8192 (default) to **524288**. In order to avoid error when we run multiple Flectra instances. This is an *optional step*. These commands are for Ubuntu user:

```
$ if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf); else echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf; fi
$ sudo sysctl -p    # apply new config immediately
```

# Custom addons

The **addons/** folder contains custom addons. Just put your custom addons if you have any.

# Flectra configuration & log

* To change Flectra configuration, edit file: **etc/flectra.conf**.
* Log file: **etc/flectra-server.log**
* Default database password (**admin_passwd**) is `flectra.info`, please change it @ [etc/flectra.conf#L55](/etc/flectra.conf#L55)

# Flectra container management

**Run Flectra**:

``` bash
docker-compose up -d
```

**Restart Flectra**:

``` bash
docker-compose restart
```

**Stop Flectra**:

``` bash
docker-compose down
```

# Live chat

In [docker-compose.yml#L21](docker-compose.yml#L21), we exposed port **20002** for live-chat on host.

Configuring **nginx** to activate live chat feature (in production):

``` conf
#...
server {
    #...
    location /longpolling/ {
        proxy_pass http://0.0.0.0:20002/longpolling/;
    }
    #...
}
#...
```

# docker-compose.yml

* flectra:2.0
* postgres:9.5

