#!/bin/bash

function printHelp() {
  echo "Usage: "
  echo "	./network.sh generate"
  echo "	./network.sh up"
  echo "	./network.sh down"
}

function generateCerts() {
  which cryptogen
  if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
  fi
  echo
  echo "============== Generate certificates using cryptogen tool =============="
  if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
  fi
  cryptogen generate --config=./crypto-config.yaml
  res=$?
  if [ $res -ne 0 ]; then
    echo "Failed to generate certificates..."
    exit 1
  fi
  echo
}

function generateChannelArtifacts() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi
  echo

  if [ -d config ]; then
    echo    
	else
		mkdir config
	fi

  echo "==============  Generating Orderer Genesis block =============="
  configtxgen -profile OneOrgOrdererGenesis -outputBlock ./config/genesis.block
  res=$?
  if [ $res -ne 0 ]; then
    echo "Failed to generate orderer genesis block..."
    exit 1
  fi
  echo
  echo "==============  Generating channel configuration transaction 'channel.tx' =============="
  configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME
  res=$?
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi
  echo
  echo "==============  Generating anchor peer update for Org1MSP  =============="
  configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
  res=$?
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for Org1MSP..."
    exit 1
  fi
}


function networkUp() {
  docker-compose up -d
  docker ps -a
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start network"
    exit 1
  fi

  docker exec cli scripts/script.sh
  if [ $? -ne 0 ]; then
    echo "ERROR !!!!"
    exit 1
  fi
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
elif [ "${MODE}" == "generate" ]; then
  generateCerts
  generateChannelArtifacts
else
  printHelp
  exit 1
fi