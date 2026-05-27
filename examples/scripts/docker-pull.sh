#!/bin/sh

# Warning! This will delete the postgres image on your local Docker instance :)

set -e

docker rmi postgres || true
asciinema rec -c "scripts/simulate-terminal.sh docker pull postgres" out/docker-pull.cast
