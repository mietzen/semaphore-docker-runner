FROM semaphoreui/runner:v2.16.28

USER root
RUN apk add --no-cache -U docker

COPY <<EOF /usr/local/bin/docker-wrapper
#!/bin/bash
if [ -n "\$SEMAPHORE_DOCKER_CONTEXT" ]; then
    if ! docker context ls -q | grep -q "\$SEMAPHORE_DOCKER_CONTEXT"; then
        echo "Docker context: "'"'"\$SEMAPHORE_DOCKER_CONTEXT"'"'" not found!"
        docker context create "\$SEMAPHORE_DOCKER_CONTEXT" --from default > /dev/null
    fi
    echo "Setting docker context to: "'"'"\$SEMAPHORE_DOCKER_CONTEXT"'"'""
    docker context use "\$SEMAPHORE_DOCKER_CONTEXT" > /dev/null
fi
source /usr/local/bin/runner-wrapper "\$@"
EOF

RUN chmod +x /usr/local/bin/docker-wrapper
RUN chown 1001:0 /usr/local/bin/docker-wrapper
USER 1001

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/docker-wrapper"]