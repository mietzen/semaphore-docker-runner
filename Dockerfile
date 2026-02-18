FROM semaphoreui/runner:v2.17.7

USER root
RUN apk add --no-cache -U docker docker-compose
RUN adduser semaphore docker

COPY <<EOF /usr/local/bin/docker-wrapper
#!/bin/bash
if [ -n "\$SEMAPHORE_DOCKER_SSH_KEY_FILE" ]; then
    echo "Adding docker ssh key..."
    mkdir -p ~/.ssh
    chmod 0700 ~/.ssh
    cat "\$SEMAPHORE_DOCKER_SSH_KEY_FILE" > ~/.ssh/docker_id
    chmod 0600 ~/.ssh/docker_id
fi
if [ -n "\$SEMAPHORE_DOCKER_HOST" ]; then
    echo "Adding docker host to config..."
    mkdir -p ~/.ssh
    chmod 0700 ~/.ssh
    echo "" >> ~/.ssh/config
    echo "Host \$SEMAPHORE_DOCKER_HOST" >> ~/.ssh/config
    echo "   IdentityFile ~/.ssh/docker_id" >> ~/.ssh/config
    echo "   StrictHostKeyChecking no" >> ~/.ssh/config
    echo "   UserKnownHostsFile=/dev/null" >> ~/.ssh/config
    chmod 0640 ~/.ssh/config
fi
source /usr/local/bin/runner-wrapper "\$@"
EOF

RUN chmod +x /usr/local/bin/docker-wrapper
RUN chown 1001:0 /usr/local/bin/docker-wrapper
USER semaphore

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/docker-wrapper"]