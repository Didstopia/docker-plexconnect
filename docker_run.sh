#!/bin/bash

./docker_build.sh

# Run the server
docker run \
  -v $(pwd)/plexconnect_data:/plexconnect \
  --name plexconnect \
  -d didstopia/docker-plexconnect:latest

docker logs -f plexconnect
