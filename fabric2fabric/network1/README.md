
```shell script
cd fabric2fabric/network1/test-network
./network.sh up 
jq ".orderers[\"orderer.example.com\"].tlsCACerts.pem=\"$(cat organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem )\" | .peers[\"peer0.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem )\" | .peers[\"peer0.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem )\"" ../metachan/connection_tp.json > ../metachan/connection.json
jq ".orderers[\"orderer.example.com\"].tlsCACerts.pem=\"$(cat organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem )\" | .peers[\"peer0.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem )\" | .peers[\"peer0.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org1.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem )\" | .certificateAuthorities[\"ca.org2.example.com\"].tlsCACerts.pem=\"$(cat organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem )\"" ../mychannel/connection_tp.json > ../mychannel/connection.json
jq ".credentials.certificate=\"$(cat organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/User1@org1.example.com-cert.pem )\" | .credentials.privateKey=\"$(cat organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/priv_sk )\"" ../user1@org1-example-com_tp.json > ../user1@org1-example-com.json

./network.sh createChannel -c metachannel 
./network.sh deployCC -ccn resourceregistry -c metachannel
./network.sh createChannel -c mychannel 
./network.sh deployCC -ccn crossprimary -c mychannel -cci InitNetwork
./network.sh deployCC -ccn verifyregistry -c mychannel
./network.sh deployCC -ccn verifynetwork2 -c mychannel
./network.sh deployCC -ccn verifynetwork3 -c mychannel

mkdir -p /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/metachannel
mkdir -p /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/mychannel
cp ../user1@org1-example-com.json /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/metachannel/user1@org1-example-com.id
cp ../user1@org1-example-com.json /tmp/crossmesh-id-path/crossmesh-fabric-test-network1/mychannel/user1@org1-example-com.id

mkdir -p /tmp/crossmesh-fabric-test-network1/crossmesh-fabric-meta-chain-conn/
cp ../metachan/connection.json /tmp/crossmesh-fabric-test-network1/crossmesh-fabric-meta-chain-conn/

#start network1 mesher

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
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C metachannel -n resourceregistry --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network1\",\"mychannel\",\"$(cat ../mychannel/connection.json | base64 )\"]}" --waitForEvent


#finish network2
#finish network3
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
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C metachannel -n resourceregistry --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network2\",\"mychannel\",\"$(cat ../../network2/mychannel/connection.json | base64 )\"]}" --waitForEvent
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C metachannel -n resourceregistry --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network3\",\"mychannel\",\"$(cat ../../network3/mychannel/connection.json | base64 )\"]}" --waitForEvent
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mychannel -n verifyregistry --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network2\",\"mychannel\",\"verifynetwork2\",\"Verify\"]}" --waitForEvent
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mychannel -n verifyregistry --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"register\",\"crossmesh-fabric-test-network3\",\"mychannel\",\"verifynetwork3\",\"Verify\"]}" --waitForEvent


peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mychannel -n crossprimary --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c "{\"Args\":[\"DoCross\",\"a\",\"b\",\"20\",\"2020-11-29T10:00:00Z\"]}" --waitForEvent
```