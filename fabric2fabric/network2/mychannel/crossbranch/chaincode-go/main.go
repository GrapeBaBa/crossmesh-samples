/*
 * SPDX-License-Identifier: Apache-2.0
 */

package main

import (
	"fmt"
	"github.com/crossmesh/crossmesh-samples/network2/crossbranch/chaincode"
	"github.com/zhigui-projects/sidemesh/plugins/fabric/transaction"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {
	contract := new(chaincode.CrossBranch)
	contract.TransactionContextHandler = new(transaction.GlobalTransactionContext)
	contract.Name = "crossmesh.network2.crossbranch"
	contract.Info.Version = "0.0.1"

	cc, err := contractapi.NewChaincode(contract)

	if err != nil {
		panic(fmt.Sprintf("Error creating cc. %s", err.Error()))
	}

	cc.Info.Title = "Network2CrossBranchChaincode"
	cc.Info.Version = "0.0.1"

	err = cc.Start()

	if err != nil {
		panic(fmt.Sprintf("Error starting cc. %s", err.Error()))
	}
}
