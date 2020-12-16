
```shell script
./network.sh up 
./network.sh createChannel -c metachannel 
./network.sh deployCC -ccn resourceregistry -c metachannel
./network.sh createChannel -c mychannel 
./network.sh deployCC -ccn crossprimary -c mychannel -cci InitNetwork
```