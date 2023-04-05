# Docker for local Sylius plugin development

All-in-one environment for easier development of Sylius plugin.

## Usage

1. Copy [docker-compose.yml](docker-compose.yml) to your plugin dir
2. Open terminal (command line) inside your plugin directory
3. Run `docker compose up`
4. Run `docker compose exec -u www-data php-sylius-plugin-dev bash`
    - docker compose is a [modern way of docker-compose](https://docs.docker.com/compose/)
    - `exec` runs a command inside Docker, using local docker-compose (yml) configs
    - `-u www-data` switches in Docker to user `www-data`, which is mapped to your current host user (see all the magic in [docker-change-user-id.sh](docker%2Fphp%2Fdocker-change-user-id.sh))
    - `php` is name of the docker service, see [docker-compose.yml](docker-compose.yml)
    - `bash` is a command to run inside that docker service
    - it is equivalent to `docker exec -ti CONTAINER_NAME bash` where CONTAINER_NAME is a dynamic name generated by
      Docker on `docker compose up`, see `docker container ls` output, column `name`
