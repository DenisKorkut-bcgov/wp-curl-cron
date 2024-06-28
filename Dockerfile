FROM --platform=linux/x86_64 alpine:3.17
RUN apk --no-cache add gcompat
RUN apk --no-cache add curl
RUN apk --no-cache add bash
RUN apk --no-cache add shadow

# Change timezone to PST for convenience
ENV TZ=America/Vancouver

# Set the workdir to be root
WORKDIR /

# ========================================================================================================
# Install go-crond (from https://github.com/webdevops/go-crond)
#
# CRON Jobs in OpenShift:
#  - https://blog.danman.eu/cron-jobs-in-openshift/
# --------------------------------------------------------------------------------------------------------
ARG SOURCE_REPO=webdevops
ARG GOCROND_VERSION=23.2.0
ADD https://github.com/$SOURCE_REPO/go-crond/releases/download/$GOCROND_VERSION/go-crond.linux.amd64 /usr/bin/go-crond

USER root

RUN chmod +x /usr/bin/go-crond
# ========================================================================================================


# ========================================================================================================
# Perform operations that require root privilages here ...
# --------------------------------------------------------------------------------------------------------
RUN echo $TZ > /etc/timezone
# ========================================================================================================

ADD *.sh /
RUN chmod +x /*.sh
# Add every minute run of curl.sh which runs curl command on the $WP_HOST env var set on the deployment, as set by the helm chart
RUN echo "* * * * * /bin/bash /curl.sh" >> /etc/crontabs/curl
RUN chmod -R gu+r /etc/crontabs

RUN echo go-crond -h

# Important - Reset to the base image's user account.


CMD ["/bin/bash", "-c", "go-crond --allow-unprivileged --auto -v"]
