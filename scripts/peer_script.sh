#!/bin/bash

CHANNEL_NAME=mychannel
DELAY=3

joinChannel () {
    sleep $DELAY

    peer channel join -b $CHANNEL_NAME.block

    echo "===================== Peer1 joined channel '$CHANNEL_NAME' ===================== "
    echo
}

installChaincode() {
    sleep $DELAY

    peer chaincode install \
        -n mycc \
        -v 1.0 \
        -p github.com/chaincode/ \
        -l golang

    echo "===================== Chaincode is installed on peer1 ===================== "
    echo
}

invokeChaincode() {
    sleep $DELAY

    peer chaincode invoke \
        -o orderer.example.com:7050 \
        -C mychannel \
        -n nda \
        -c '{"Args":["invoke","a","b","10"]}'

    echo "===================== Invoke on channel '$CHANNEL_NAME' ===================== "
    echo
}

queryChaincode() {
    sleep $DELAY

    peer chaincode query \
        -C mychannel \
        -n mycc \
        -c '{"Args":["query","a"]}'

    echo "===================== Query on channel '$CHANNEL_NAME' ===================== "
    echo
}

getChannelInfo() {
    peer channel getinfo -c mychannel
}

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp 
CORE_PEER_ADDRESS=peer1.org1.example.com:8051 
CORE_PEER_LOCALMSPID="Org1MSP" 
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt 

echo "Having peer1 join the channel..."
joinChannel

echo "Installing chaincode..."
installChaincode

echo "Instantiating chaincode..."
invokeChaincode

echo "Querying chaincode..."
queryChaincode

echo "Getting channel Info..."
getChannelInfo