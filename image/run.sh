#!/bin/sh

printf "master: saltdock_master\nid: saltdock_${SALT_TYPE}_${HOSTNAME}" > /etc/salt/minion


exec "$@"
