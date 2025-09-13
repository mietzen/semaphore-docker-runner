# Semaphore Docker Runner with Docker Context Support

A custom Docker image based on `semaphoreui/runner` that adds Docker CLI support with automatic Docker context management.

## Usage

```yaml
services:
  semaphore-runner:
    image: mietzen/semaphore-docker-runner:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
        SEMAPHORE_WEB_ROOT: http://semaphore:3000
        SEMAPHORE_RUNNER_REGISTRATION_TOKEN: yourtoken
        SEMAPHORE_DOCKER_CONTEXT: your-context # Optional if you use community.docker.docker_compose_v2 with context
```
