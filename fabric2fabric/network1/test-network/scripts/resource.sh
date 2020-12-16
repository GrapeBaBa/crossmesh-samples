#!/bin/bash

export CORE_PEER_TLS_ENABLED=true;
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem;
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt;
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt;

export CORE_PEER_LOCALMSPID="Org1MSP";
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA;
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp;
export CORE_PEER_ADDRESS=localhost:7051;

export PATH=${PWD}/../bin:$PATH;
export FABRIC_CFG_PATH=$PWD/../config/;
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C metachannel -n resourceregistry --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network1\",\"mychannel\",\"$(cat ../mychannel/connection.json | base64 )\"]}" --waitForEvent;
