FROM semaphoreui/runner:v2.16.29

USER root
RUN apk add --no-cache -U docker
RUN adduser semaphore docker

COPY <<EOF /usr/local/bin/docker-wrapper
#!/bin/bash
if [ -n "\$SEMAPHORE_DOCKER_SSH_KEY" ]; then
    echo "Adding docker ssh key..."
    mkdir -p ~/.ssh
    chmod 0700 ~/.ssh
    echo "\$SEMAPHORE_DOCKER_SSH_KEY" > ~/.ssh/docker_id
    chmod 0600 ~/.ssh/docker_id
    echo "Added docker_id:"
    ls -al ~/.ssh/docker_id
fi
source /usr/local/bin/runner-wrapper "\$@"
EOF

RUN chmod +x /usr/local/bin/docker-wrapper
RUN chown 1001:0 /usr/local/bin/docker-wrapper
USER semaphore

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/docker-wrapper"]