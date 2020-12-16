package chaincode

import (
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type Network3 struct {
	contractapi.Contract
}

func (network3 *Network3) Verify(ctx contractapi.TransactionContextInterface, txID string, proof string) (bool, error) {
	//TODO:
	fmt.Println(txID)
	fmt.Println(proof)
	return true, nil
}
