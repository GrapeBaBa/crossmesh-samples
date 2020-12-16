#!/bin/bash

export CORE_PEER_TLS_ENABLED=true;
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem;
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org13.example.com/peers/peer0.org13.example.com/tls/ca.crt;
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org23.example.com/peers/peer0.org23.example.com/tls/ca.crt;

export CORE_PEER_LOCALMSPID="Org13MSP";
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA;
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org13.example.com/users/Admin@org13.example.com/msp;
export CORE_PEER_ADDRESS=localhost:7251;

export PATH=${PWD}/../bin:$PATH;
export FABRIC_CFG_PATH=$PWD/../config/;
peer chaincode invoke -o localhost:7250 --tls --cafile $ORDERER_CA -C metachannel -n resourceregistry --peerAddresses localhost:7251 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9251 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network1\",\"mychannel\",\"$(cat ../../network1/mychannel/connection.json | base64 )\"]}" --waitForEvent;
peer chaincode invoke -o localhost:7250 --tls --cafile $ORDERER_CA -C mychannel -n verifyregistry --peerAddresses localhost:7251 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9251 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network1\",\"mychannel\",\"verifynetwork1\",\"Verify\"]}" --waitForEvent

