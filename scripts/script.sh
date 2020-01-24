#!/bin/bash

CHANNEL_NAME=mychannel
DELAY=3

createChannel() {
    sleep $DELAY

    peer channel create \
        -o orderer.example.com:7050 \
        -c $CHANNEL_NAME \
        -f ./config/channel.tx 
    
	echo "===================== Channel '$CHANNEL_NAME' created ===================== "
	echo
}

joinChannel () {
    sleep $DELAY

    peer channel join -b $CHANNEL_NAME.block

    echo "===================== Peer0 joined channel '$CHANNEL_NAME' ===================== "
    echo
}

installChaincode() {
    sleep $DELAY

    peer chaincode install ../../../chaincode/mycc.pak

    echo "===================== Chaincode is installed on peer0 ===================== "
    echo
}

instantiateChaincode() {
    sleep $DELAY

    peer chaincode instantiate \
        -o orderer.example.com:7050 \
        -C $CHANNEL_NAME \
        -n mycc \
        -l golang \
        -v 1.0 \
        -c '{"Args":["init","a","100","b","200"]}'

    echo "===================== Chaincode is instantiated on channel '$CHANNEL_NAME' ===================== "
    echo
}

invokeChaincode() {
    sleep $DELAY

    peer chaincode invoke \
        -o orderer.example.com:7050 \
        -C $CHANNEL_NAME \
        -n mycc \
        -c '{"Args":["invoke","a","b","10"]}'

    echo "===================== Chaincode is invoked on channel '$CHANNEL_NAME' ===================== "
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

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
CORE_PEER_ADDRESS=peer0.org1.example.com:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

echo "Creating channel..."
createChannel

echo "Having peer0 join the channel..."
joinChannel

echo "Installing chaincode..."
installChaincode

echo "Instantiating chaincode..."
instantiateChaincode

echo "Invoking chaincode..."
invokeChaincode

echo "Querying chaincode..."
queryChaincode