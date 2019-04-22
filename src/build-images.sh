#!/bin/bash

docker pull mongo:latest
docker build -t bessonovd/prometheus ../monitoring/prometheus
docker build -t bessonovd/post:1.0 ./post-py
docker build -t bessonovd/comment:1.0 ./comment
docker build -t bessonovd/ui:1.0 ./ui

