#!/bin/bash

./network.sh up;
jq ".orderers[\"orderer1.example.com\"].tlsCACerts.pem=\"$(cat organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem )\" | .peers[\"peer0.org12.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org12.example.com/tlsca/tlsca.org12.example.com-cert.pem )\" | .peers[\"peer0.org22.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org22.example.com/tlsca/tlsca.org22.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org12.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org12.example.com/ca/ca.org12.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org22.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org22.example.com/ca/ca.org22.example.com-cert.pem )\"" ../metachan/connection_tp.json > ../metachan/connection.json;
jq ".orderers[\"orderer1.example.com\"].tlsCACerts.pem=\"$(cat organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem )\" | .peers[\"peer0.org12.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org12.example.com/tlsca/tlsca.org12.example.com-cert.pem )\" | .peers[\"peer0.org22.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org22.example.com/tlsca/tlsca.org22.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org12.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org12.example.com/ca/ca.org12.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org22.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org22.example.com/ca/ca.org22.example.com-cert.pem )\"" ../mychannel/connection_tp.json > ../mychannel/connection.json;
jq ".credentials.certificate=\"$(cat organizations/peerOrganizations/org12.example.com/users/User1@org12.example.com/msp/signcerts/User1@org12.example.com-cert.pem )\" | .credentials.privateKey=\"$(cat organizations/peerOrganizations/org12.example.com/users/User1@org12.example.com/msp/keystore/priv_sk )\"" ../user1@org12-example-com_tp.json > ../user1@org12-example-com.json;

./network.sh createChannel -c metachannel;
./network.sh deployCC -ccn resourceregistry -c metachannel;
./network.sh createChannel -c mychannel;
./network.sh deployCC -ccn verifyregistry -c mychannel;
./network.sh deployCC -ccn verifynetwork1 -c mychannel;
./network.sh deployCC -ccn crossbranch -c mychannel -cci InitNetwork;

mkdir -p /tmp/crossmesh-id-path/crossmesh-fabric-test-network3/metachannel;
mkdir -p /tmp/crossmesh-id-path/crossmesh-fabric-test-network3/mychannel;
cp ../user1@org12-example-com.json /tmp/crossmesh-id-path/crossmesh-fabric-test-network3/metachannel/user1@org12-example-com.id;
cp ../user1@org12-example-com.json /tmp/crossmesh-id-path/crossmesh-fabric-test-network3/mychannel/user1@org12-example-com.id;

mkdir -p /tmp/crossmesh-fabric-test-network3/crossmesh-fabric-meta-chain-conn/;
cp ../metachan/connection.json /tmp/crossmesh-fabric-test-network3/crossmesh-fabric-meta-chain-conn/;
