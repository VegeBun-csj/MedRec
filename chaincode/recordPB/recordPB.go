package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

//该链码运行在channelPB上

type RecordCC struct {

}

func (recordb *RecordCC)Init(stub shim.ChaincodeStubInterface)pb.Response  {
	return shim.Success(nil)
}

//键名是RecordId
func (recordb *RecordCC) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fn,args:= stub.GetFunctionAndParameters()
	fmt.Printf("方法为:%s  参数为%s \n",fn,args)
	if fn =="addInfo"{
		return recordb.addRecord(stub,args)
	}else if fn == "seleInfo"{
		return recordb.seleInfo(stub,args)
	}
	return shim.Error("请输入正确的方法名,usage:addInfo/seleInfo")
}


//直接后台使用RSA对IPFS的hash值进行加密
func (recordb *RecordCC)addRecord(stub shim.ChaincodeStubInterface,args []string)pb.Response  {
	if len(args)!=2 {
		shim.Error("输入的参数有误，请输入加密后的密文")
	}
	stub.PutState(args[0],[]byte(args[1]));
	return shim.Success(nil)

}


//获取IPFS加密的密文
func (recordb *RecordCC)seleInfo(stub shim.ChaincodeStubInterface,args []string)pb.Response  {
	if len(args)!=1 {
		shim.Error("输入的参数有误，请输入加密后的密文")
	}
	miwen, _ := stub.GetState(args[0])
	return shim.Success(miwen)
}


func main() {
	err := shim.Start(new (RecordCC))
	if err!=nil{
		fmt.Printf("创建Info链码失败：%s",err)
	}

}
