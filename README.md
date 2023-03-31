
# wp-curl-cron

Docker image that runs periodically runs a curl command to the WordPress ([REST API plugin](https://github.com/spencercrose/wp-cron-hook)) to run cron scripts. This is used within a long-running deployment.

Go-cron adapted from ([backup-container](https://github.com/BCDevOps/backup-container/blob/master/docker/Dockerfile#L13-L26))

### Required Environment Variable:

* `WP_HOST`: The hostname of the wordpress host to ping 


## Examples:

Run locally on your development environment:

    docker run -it -e WP_HOST=wordpress.hostname.com $(docker build -q .)


