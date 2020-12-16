/*
 * SPDX-License-Identifier: Apache-2.0
 */

package main

import (
	"fmt"
	"github.com/crossmesh/crossmesh-samples/network3/verifyregistry/chaincode"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {

	contract := new(chaincode.Registry)
	contract.Name = "crossmesh.network3.verifyregistry"
	contract.Info.Version = "0.0.1"

	cc, err := contractapi.NewChaincode(contract)

	if err != nil {
		panic(fmt.Sprintf("Error creating cc. %s", err.Error()))
	}

	cc.Info.Title = "Network3VerifyRegistryChaincode"
	cc.Info.Version = "0.0.1"

	err = cc.Start()

	if err != nil {
		panic(fmt.Sprintf("Error starting cc. %s", err.Error()))
	}
}
