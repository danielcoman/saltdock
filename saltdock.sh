#!/bin/bash

# Swarm is incompatible with features needed for a systemd image
# saltdock.sh imitates swarm format and adds systemd deb image to swarm network

# Swarm network
network="saltdock_internal"
namespace="saltdock"

# Image, fallback to deb
if [[ $3 -eq $3 ]] ; then
  img_type=$3
else
  img_type="deb"
fi

img="saltdock_img_${img_type}_systemd"

# Naming and scope
name="cluster"
SALT_TYPE="minion"

# Check network prerequisite
swarm_check () {
docker network ls | grep ${network}
[ $? -ne 0 ] && echo "Error. First build saltdock env first." && exit 1
}

# Reproduce docker swarm naming scheme
swarm_name () {
  increment_list=$(docker ps -a --format "{{.Names}}" | grep "${name}_${img_type}" | awk -F'.' '{print $2}')
  increment=$(for nr in ${increment_list} ; do echo $nr ; done | sort -nr | head -1)
  [[ increment -eq increment ]] && increment=$((increment+1)) || increment=0 > /dev/null 2>&1
}

add () {
  docker run -d \
    --name "saltdock_${name}_${img_type}.${increment}.$(openssl rand -hex 10)" \
    --security-opt seccomp=unconfined \
    --tmpfs /run --tmpfs /run/lock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --network=${network} \
    --hostname="${name}_${increment}" \
    --env SALT_TYPE=${SALT_TYPE} \
    ${img}:latest
}

remove () {
  docker stop `docker ps | grep ${namespace} | awk '{print $1}' `
  docker rm `docker ps -a | grep ${namespace} | awk '{print $1}' `
}

# # config
# init () {
# mkdir -p /var/saltdock && touch ${conf} > /dev/null 2>&1
# }

case "$1" in
  add)
    swarm_check
    if [ -z "$2" ] ; then
      swarm_name && add
    elif [ $2 -eq $2 ] ; then
      for i in $(seq $2) ; do
        swarm_name && add
      done
    else
      echo "Add error" && exit 1
    fi
    ;;
  rm)
    remove
    ;;
  *)
    echo "Usage: $0 {add|remove}"
    exit 1
    ;;
esac
