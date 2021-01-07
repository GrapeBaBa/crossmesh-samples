# Introduction
It demonstrates chaincode invocation crossing three fabric networks. You can find the flow diagram at 'Cross Chain Use Case' section in the [doc](https://docs.google.com/document/d/1ODcQl_JGduqHks0GnPObaI-ZOYX2LLT7C1_v4M0MYJE/edit#) 

# Run
1.Open terminal1
```shell
cd fabric2fabric/network1/test-network
```
2.Open terminal2
```shell
cd fabric2fabric/network2/test-network
```
3.Open terminal3
```shell
cd fabric2fabric/network3/test-network
```
4.In terminal1
```shell
./scripts/prepare.sh
```
5.In terminal2
```shell
./scripts/prepare.sh
```
6.In terminal3
```shell
./scripts/prepare.sh
```
7.Start network1 Mesher, clone mesher repo and run
```shell
SPRING_PROFILES_ACTIVE=net1 ./gradlew bootRun
```
8.Start network2 Mesher
```shell
SPRING_PROFILES_ACTIVE=net2 ./gradlew bootRun
```
9.Start network3 Mesher, clone mesher repo and run
```shell
SPRING_PROFILES_ACTIVE=net3 ./gradlew bootRun
```
10.In terminal1
```shell
./scripts/resource.sh 
```
11.In terminal2
```shell
./scripts/resource.sh 
```
12.In terminal3
```shell
./scripts/resource.sh 
```
13.In terminal1
```shell
./scripts/othernet.sh  
```
14.In terminal2
```shell
./scripts/othernet.sh  
```
15.In terminal3
```shell
./scripts/othernet.sh  
```
16.In terminal1, invoke primary prepare transaction
```shell
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/

peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mychannel -n crossprimary --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"DoCross\",\"a\",\"b\",\"20\",\"2020-11-29T10:00:00Z\"]}" --waitForEvent
```