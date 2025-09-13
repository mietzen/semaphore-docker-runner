FROM semaphoreui/runner:v2.16.28
USER root
RUN apk add --no-cache -U docker su-exec

COPY <<EOF /usr/local/bin/docker-wrapper
#!/bin/bash

if [ -S /var/run/docker.sock ]; then
    DOCKER_GID=\$(stat -c %g /var/run/docker.sock)
    echo "Detected Docker socket GID: \$DOCKER_GID"

    delgroup docker 2>/dev/null || true
    addgroup -g \$DOCKER_GID docker

    adduser semaphore docker
else
    echo "Error: Docker socket not found at /var/run/docker.sock"
    exit 1
fi

if [ -n "\$SEMAPHORE_DOCKER_CONTEXT" ]; then
    if ! docker context ls -q | grep -q "\$SEMAPHORE_DOCKER_CONTEXT"; then
        echo "Docker context: "'"'"\$SEMAPHORE_DOCKER_CONTEXT"'"'" not found!"
        docker context create "\$SEMAPHORE_DOCKER_CONTEXT" --from default > /dev/null
    fi
    echo "Setting docker context to: "'"'"\$SEMAPHORE_DOCKER_CONTEXT"'"'""
    docker context use "\$SEMAPHORE_DOCKER_CONTEXT" > /dev/null
fi

su-exec semaphore /usr/local/bin/runner-wrapper "\$@"
EOF

RUN chmod +x /usr/local/bin/docker-wrapper

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/docker-wrapper"]