/*
 * SPDX-License-Identifier: Apache-2.0
 */

package main

import (
	"fmt"
	"github.com/crossmesh/crossmesh-samples/network1/verifynetwork2/chaincode"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {

	contract := new(chaincode.Network2)
	contract.Name = "crossmesh.network1.verifynetwork2"
	contract.Info.Version = "0.0.1"

	cc, err := contractapi.NewChaincode(contract)

	if err != nil {
		panic(fmt.Sprintf("Error creating cc. %s", err.Error()))
	}

	cc.Info.Title = "Network1VerifyNetwork2Chaincode"
	cc.Info.Version = "0.0.1"

	err = cc.Start()

	if err != nil {
		panic(fmt.Sprintf("Error starting cc. %s", err.Error()))
	}
}
