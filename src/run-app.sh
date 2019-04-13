#!/bin/bash

docker network create reddit
docker run -d --network=reddit --network-alias=post_db --name=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post --name=post bessonovd/post:1.0
docker run -d --network=reddit --network-alias=comment --name=comment bessonovd/comment:1.0
docker run -d --network=reddit -p 9292:9292 --name=ui bessonovd/ui:1.0
