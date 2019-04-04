#!/usr/bin/env bash

docker-compose up --abort-on-container-exit

docker-compose -f docker-compose.hostnetwork.yml up --abort-on-container-exit

docker-compose -f docker-compose.kubernetes.yml up --abort-on-container-exit
