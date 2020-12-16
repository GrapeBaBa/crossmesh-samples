package chaincode

import (
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type Network1 struct {
	contractapi.Contract
}

func (network1 *Network1) Verify(ctx contractapi.TransactionContextInterface, txID string, proof string) (bool, error) {
	//TODO:
	fmt.Println(txID)
	fmt.Println(proof)
	return true, nil
}
