# Hyperledger Fabric - multi peers on different hosts

## Below steps are for new peer host. Change branch to 'master' for master host.
```
git checkout master
```

## Run docker-compose
```
docker-compose up
```

## Fetch the channel
```
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer1.org1.example.com peer channel fetch config -o orderer.example.com:7050 -c mychannel
```
## Join peer1.org1.example.com to the channel.
```
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer1.org1.example.com peer channel join -b mychannel_config.block
```

http://localhost:5984/_utils -> for couchdb