package chaincode

import (
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/zhigui-projects/sidemesh"
	"github.com/zhigui-projects/sidemesh/plugins/fabric/transaction"
)

type CrossPrimary struct {
	contractapi.Contract
}

func (crossPrimary *CrossPrimary) InitNetwork(ctx contractapi.TransactionContextInterface) error {
	err := ctx.GetStub().PutState(sidemesh.Prefix+"NetworkID", []byte("crossmesh-fabric-test-network1"))
	if err != nil {
		return err
	}
	return nil
}

func (crossPrimary *CrossPrimary) DoCross(ctx transaction.GlobalTransactionContextInterface, a string, b string, ttlHeight uint64, ttlTime string) (string, error) {
	err := ctx.GetGlobalTransactionManager().StartGlobalTransaction(ttlHeight, ttlTime)
	if err != nil {
		return "", err
	}

	err = ctx.GetLockManager().PutLockedStateWithPrimaryLock("testlocka", []byte(a))
	if err != nil {
		return "", err
	}

	err = ctx.GetLockManager().PutLockedStateWithPrimaryLock("testlockb", []byte(b))
	if err != nil {
		return "", err
	}

	err = ctx.GetGlobalTransactionManager().RegisterBranchTransaction("crossmesh-fabric-test-network2", "mychannel", "crossbranch", "DoBranch", []string{a + b})
	if err != nil {
		return "", err
	}

	err = ctx.GetGlobalTransactionManager().RegisterBranchTransaction("crossmesh-fabric-test-network3", "mychannel", "crossbranch", "DoBranch", []string{b})
	if err != nil {
		return "", err
	}

	err = ctx.GetGlobalTransactionManager().PreparePrimaryTransaction()
	if err != nil {
		return "", err
	}

	return a + b, nil
}

func (crossPrimary *CrossPrimary) ConfirmDoCross(ctx transaction.GlobalTransactionContextInterface, primaryPrepareTxID string, network2 string, chain2 string, tx2Id string, tx2Proof string, network3 string, chain3 string, tx3Id string, tx3Proof string) error {
	allBranchTxRes := [][]string{{network2, chain2, tx2Id, tx2Proof}, {network3, chain3, tx3Id, tx3Proof}}

	err := ctx.GetGlobalTransactionManager().ConfirmPrimaryTransaction(primaryPrepareTxID, allBranchTxRes)
	if err != nil {
		return err
	}

	return nil
}
