#!/bin/bash

docker run -d --network=front_net -p 9292:9292 --name ui bessonovd/ui:1.0
docker run -d --network=back_net --name comment bessonovd/comment:1.0
docker run -d --network=back_net --name post bessonovd/post:1.0
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
