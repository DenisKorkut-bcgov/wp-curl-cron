FROM alpine:3.17

RUN apk --no-cache add curl

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
RUN echo "* * * * * ./curl.sh" >> /etc/crontabs/curl
RUN chmod -R gu+r /etc/crontabs

RUN echo go-crond -h

# Important - Reset to the base image's user account.
USER 26
CMD go-crond -v --allow-unprivileged --auto