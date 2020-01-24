# Hyperledger Fabric - multi peers on different hosts

## Below steps are for master host. Change branch to 'new_peer' for peer host.
```
git checkout new_peer
```
### Update IP address in .env file
### Run in master host.
```
./network up
```
### Start new peer in other host from 'new_peer' branch
### Run in peer host.
```
./network up
```
### Run in master host.
```
./network join
```

# (OR)

## Run docker-compose
```
docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com couchdb
```

## Create the channel
```
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx
```
## Join peer0.org1.example.com to the channel.
```
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block
```


# (OR)

```
docker-compose up
```

Open new Terminal

```
docker exec -it cli bash

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
CORE_PEER_ADDRESS=peer0.org1.example.com:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

peer channel create \
    -o orderer.example.com:7050 \
    -c mychannel \
    -f ./config/channel.tx

peer channel join -b mychannel.block

peer chaincode install ../../../chaincode/mycc.pak

peer chaincode instantiate \
    -o orderer.example.com:7050 \
    -C mychannel \
    -n mycc \
    -l golang \
    -v 1.0 \
    -c '{"Args":["init","a","100","b","200"]}' 

peer chaincode query \
    -C mychannel \
    -n mycc \
    -c '{"Args":["query","a"]}'

peer chaincode invoke \
    -o orderer.example.com:7050 \
    -C mychannel \
    -n mycc \
    -c '{"Args":["invoke","a","b","10"]}'

peer channel getinfo -c mychannel

peer channel fetch newest \
    -o orderer.example.com:7050 \
    -c mychannel \
    last.block
```

http://localhost:5984/_utils -> for couchdb