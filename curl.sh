#!/bin/sh
set -e

echo "$(date) - Start"
curl --insecure https://${WP_HOST}/wp-json/wpch/v1/cron