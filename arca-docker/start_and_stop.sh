#!/bin/bash

# start container with docker-compose up
start () {
    docker-compose up -d       
}

# stop container with docker-compose down
stop () {
    docker-compose down
}

if [[ $1 == "start" ]]
then
    echo "Starting all docker containers..."
    start
elif [[ $1 == "stop" ]]
then
    echo "Stopping all docker containers..."
    stop
else
    echo -e "Bash script to start or stop docker container...\n"
    echo -e "Usage: $0 [start or stop]\n"
fi


