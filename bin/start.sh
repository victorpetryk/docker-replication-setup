#!/bin/bash

docker-compose up -d
sleep 15 # wait until MySQL servers start
sh ./bin/_build.sh