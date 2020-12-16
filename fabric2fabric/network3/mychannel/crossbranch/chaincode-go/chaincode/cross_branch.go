package chaincode

import (
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/zhigui-projects/sidemesh"
	"github.com/zhigui-projects/sidemesh/plugins/fabric/transaction"
	"strconv"
)

type CrossBranch struct {
	contractapi.Contract
}

func (crossBranch *CrossBranch) InitNetwork(ctx contractapi.TransactionContextInterface) error {
	err := ctx.GetStub().PutState(sidemesh.Prefix+"NetworkID", []byte("crossmesh-fabric-test-network3"))
	if err != nil {
		return err
	}
	return nil
}

func (crossBranch *CrossBranch) DoBranch(ctx transaction.GlobalTransactionContextInterface, value string, globalTxQueryContract string, globalTxQueryFunc string, primaryPrepareTxNetwork string, primaryPrepareTxChain string, primaryPrepareTxID string, primaryPrepareTxProof string) (string, error) {
    fmt.Println("1")
	err := ctx.GetGlobalTransactionManager().StartBranchTransaction(primaryPrepareTxNetwork, primaryPrepareTxChain, primaryPrepareTxID, primaryPrepareTxProof)
	if err != nil {
		return "", err
	}
	fmt.Println("2")
	err = ctx.GetLockManager().PutLockedStateWithBranchLock("testlocka", []byte(value), primaryPrepareTxNetwork, primaryPrepareTxChain, primaryPrepareTxID)
	if err != nil {
		return "", err
	}
	fmt.Println("3")
	err = ctx.GetGlobalTransactionManager().PrepareBranchTransaction(primaryPrepareTxNetwork, primaryPrepareTxChain, primaryPrepareTxID, globalTxQueryContract, globalTxQueryFunc)
	if err != nil {
		return "", err
	}

	return value, nil
}

func (crossBranch *CrossBranch) ConfirmDoBranch(ctx transaction.GlobalTransactionContextInterface,branchPrepareTxID string, globalTxStatusStr string,primaryConfirmTxNetwork string,primaryConfirmTxChain string,primaryConfirmTxID string,primaryConfirmTxProof string) error {
	globalTxStatus, err := strconv.Atoi(globalTxStatusStr)
	if err != nil {
		return err
	}

	err = ctx.GetGlobalTransactionManager().ConfirmBranchTransaction(branchPrepareTxID, globalTxStatus, primaryConfirmTxNetwork, primaryConfirmTxChain, primaryConfirmTxID, primaryConfirmTxProof)
	if err != nil {
		return err
	}

	return nil
}
