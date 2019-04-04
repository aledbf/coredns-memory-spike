#!/usr/bin/env bash

docker-compose -f docker-compose.kubernetes-go-dnsperf.yml up --abort-on-container-exit --scale go-dnsperf=100
