#!/bin/bash

CHANNEL_NAME=mychannel
DELAY=3

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

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp 
CORE_PEER_ADDRESS=peer1.org1.example.com:8051 
CORE_PEER_LOCALMSPID="Org1MSP" 
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt 

echo "Installing chaincode..."
installChaincode

echo "Instantiating chaincode..."
invokeChaincode
