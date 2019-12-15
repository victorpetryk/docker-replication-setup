#!/bin/bash

docker-compose up -d
sleep 10 # wait until MySQL servers start
sh ./bin/_build.sh