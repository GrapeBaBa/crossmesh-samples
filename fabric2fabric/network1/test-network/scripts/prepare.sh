#!/bin/bash

./network.sh up;
jq ".orderers[\"orderer.example.com\"].tlsCACerts.pem=\"$(cat organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem )\" | .peers[\"peer0.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem )\" | .peers[\"peer0.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem )\"" ../metachan/connection_tp.json > ../metachan/connection.json;
jq ".orderers[\"orderer.example.com\"].tlsCACerts.pem=\"$(cat organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem )\" | .peers[\"peer0.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem )\" | .peers[\"peer0.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem )\"" ../mychannel/connection_tp.json > ../mychannel/connection.json;
jq ".credentials.certificate=\"$(cat organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/User1@org1.example.com-cert.pem )\" | .credentials.privateKey=\"$(cat organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/priv_sk )\"" ../user1@org1-example-com_tp.json > ../user1@org1-example-com.json;

./network.sh createChannel -c metachannel;
./network.sh deployCC -ccn resourceregistry -c metachannel;
./network.sh createChannel -c mychannel;
./network.sh deployCC -ccn crossprimary -c mychannel -cci InitNetwork;
./network.sh deployCC -ccn verifyregistry -c mychannel;
./network.sh deployCC -ccn verifynetwork2 -c mychannel;
./network.sh deployCC -ccn verifynetwork3 -c mychannel;

mkdir -p /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/metachannel;
mkdir -p /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/mychannel;
cp ../user1@org1-example-com.json /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/metachannel/user1@org1-example-com.id;
cp ../user1@org1-example-com.json /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/mychannel/user1@org1-example-com.id;

mkdir -p /tmp/crossmesh-fabric-test-network1/crossmesh-fabric-meta-chain-conn/;
cp ../metachan/connection.json /tmp/crossmesh-fabric-test-network1/crossmesh-fabric-meta-chain-conn/;
