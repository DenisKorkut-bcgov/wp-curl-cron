#!/bin/bash
curl --insecure https://${WP_HOST}/wp-json/wpch/v1/cron

n=0
end=5
while [ $n -le $end ]; do
    network_env="WP_NETWORK_$n"
    network=${!network_env}

    if [ -n "${network}" ]; then
        curl --insecure https://${WP_HOST}/$network/wp-json/wpch/v1/cron
    fi
    n=$((n+1))
done
