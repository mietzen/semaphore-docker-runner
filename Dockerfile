FROM semaphoreui/runner:v2.16.28

USER root
RUN apk add --no-cache -U docker
RUN adduser semaphore docker
USER semaphore

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/docker-runner"]
