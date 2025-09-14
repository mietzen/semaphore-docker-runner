# Semaphore Docker Runner with Docker Context Support

A custom Docker image based on `semaphoreui/runner` with added Docker CLI.

## Usage

```yaml
services:
  semaphore-runner:
    image: mietzen/semaphore-docker-runner:latest
    container_name: semaphore_runner
    restart: unless-stopped
    depends_on:
      - semaphore
    environment:
      SEMAPHORE_WEB_ROOT: http://semaphore:3000
      SEMAPHORE_RUNNER_TOKEN: ${SEMAPHORE_RUNNER_TOKEN}
      SEMAPHORE_DOCKER_HOST: my.docker.host
      SEMAPHORE_RUNNER_PRIVATE_KEY_FILE: /run/secrets/runner_key
      SEMAPHORE_DOCKER_SSH_KEY_FILE: /run/secrets/docker_ssh_key
    secrets:
      - runner_key
      - docker_ssh_key
    volumes:
      - semaphore_runner_data:/var/lib/semaphore
      - semaphore_runner_config:/etc/semaphore
      - semaphore_runner_tmp:/tmp/semaphore
    healthcheck:
      test: ["CMD-SHELL", "ping -c 1 semaphore"]
      interval: 10s
      timeout: 5s
      retries: 5
```
