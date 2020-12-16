#!/bin/bash

export CORE_PEER_TLS_ENABLED=true;
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem;
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org12.example.com/peers/peer0.org12.example.com/tls/ca.crt;
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org22.example.com/peers/peer0.org22.example.com/tls/ca.crt;

export CORE_PEER_LOCALMSPID="Org12MSP";
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA;
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org12.example.com/users/Admin@org12.example.com/msp;
export CORE_PEER_ADDRESS=localhost:7151;

export PATH=${PWD}/../bin:$PATH;
export FABRIC_CFG_PATH=$PWD/../config/;
peer chaincode invoke -o localhost:7150 --tls --cafile $ORDERER_CA -C metachannel -n resourceregistry --peerAddresses localhost:7151 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9151 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network3\",\"mychannel\",\"$(cat ../mychannel/connection.json | base64 )\"]}" --waitForEvent;
