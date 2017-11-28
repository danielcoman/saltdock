# saltdock
SaltStack in Docker (Compose, Swarm)

Quickly spin up a slick SaltStack dev env using the Docker ecosystem.  
Docker Compose and Docker Swarm is used to bootstrap the env.  
```
├── README.md
├── image
│   ├── Dockerfile.deb ------------------> Ubuntu
│   ├── Dockerfile.deb_systemd ----------> Ubuntu with systemd
│   ├── Dockerfile.rpm_systemd ----------> Centos 7.x with systemd
│   ├── repo
│   │   ├── SALTSTACK-GPG-KEY.pub
│   │   └── saltstack.list
│   └── run.sh
├── other
├── saltdock.sh ------------------------> Use this script to spin up containers with systemd
├── saltdock_build.yml
├── saltdock_deploy.yml
└── vol
    ├── etc
    │   └── salt --------------------> Default master conf provided, edit it if needed
    └── srv
        └── salt --------------------> Salt states, formulas, pillars
```

Versions:
```
ubuntu:16.04
Centos 7.x
salt:2017.7.2
```
Salt configurations:
```
auto_accept: True
```

## 1 Start saltdock

Inside cloned repo folder run:

1.1 Build images:
```
docker-compose -f build.yml build
```
1.2 Init single node docker swarm:
```
docker swarm init   
```
1.3. Deploy stack on docker swarm:
```
docker stack deploy -c deploy.yml saltdock
```
If this step fails due to race condition with container needing network first just run it a few times util you are lucky.


## 2 Systemd containers - saltdock cli

Containers with systemd are not supported in Docker Compose or Swarm.

2.1 Add an ubuntu systemd container.
```
./saltdock.sh add 3 deb
```
2.2 Add to path
```
ln -s ~/saltdock/saltdock.sh /usr/local/bin/saltdock
```

## 3 Remove saltdock

3.1 Remove ubuntu systemd containers first:
```
saltdock rm
```

3.2 Remove the stack
```
docker stack rm saltdock
````

## 4 Extras

Minion keys are stored in a local volume, to clean dead ones:

```
salt-run manage.down removekeys=True

```

Shell shortcuts:
```
#saltdock
alias dps="docker ps"
alias dpsa="docker ps -a"

alias dstop='docker stop `docker ps --format "{{.ID}}"`'

alias drm='docker rm `docker ps --format "{{.ID}}"`'
alias drma='docker rm `docker ps -a --format "{{.ID}}"`'

dexec() { docker exec -ti $1 bash }
```



Salt useful stuff:
```
salt '*' saltutil.pillar_refresh
salt '*' mine.update
salt '*' saltutil.sync_all
salt '*' state.highstate
```
