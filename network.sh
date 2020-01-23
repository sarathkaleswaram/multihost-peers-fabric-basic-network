#!/bin/bash

function printHelp() {
  echo "Usage: "
  echo "	./network.sh up"
  echo "	./network.sh down"
}

function networkUp() {
  docker-compose up -d
  docker ps -a
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start network"
    exit 1
  fi

  echo "Fetching the channel"
  docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer1.org1.example.com peer channel fetch config -o orderer.example.com:7050 -c mychannel

  echo "Joining peer1.org1.example.com to the channel"
  docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer1.org1.example.com peer channel join -b mychannel_config.block
}


function networkDown() {
  docker-compose down --volumes --remove-orphans
  docker rmi -f $(docker images | grep basic | awk {'print $3'})
  docker container rm $(docker container ps -aq)
  y | docker network prune
  echo
}


CHANNEL_NAME=mychannel
MODE=$1
if [ "${MODE}" == "up" ]; then
  networkUp
elif [ "${MODE}" == "down" ]; then
  networkDown
else
  printHelp
  exit 1
fi