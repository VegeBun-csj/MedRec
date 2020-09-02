package main

import (
	"bytes"
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
	"strconv"
	"time"
)

//该链码运行在channelPB上

//键名是RecordId   doctor-patient1-doctor-patient99

type RecordACC struct {

}


func (recorda *RecordACC)Init(stub shim.ChaincodeStubInterface)pb.Response  {
	return shim.Success(nil)
}

func (recorda *RecordACC) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fn,args:= stub.GetFunctionAndParameters()
	fmt.Printf("方法为:%s  参数为%s \n",fn,args)
	if fn =="addRecord"{
		return recorda.addRecord(stub,args)
	}else if fn == "seleInfo"{
		return recorda.seleInfo(stub,args)
	}else if fn =="getHistoryForPatient"{
		return recorda.getHistoryForPatient(stub,args)
	}
	
	return shim.Error("请输入正确的方法名,正确的方法名应为:addRecord/seleInfo/getHistoryForPatient")
}


//直接后台使用RSA对IPFS的hash值进行加密
func (recorda *RecordACC)addRecord(stub shim.ChaincodeStubInterface,args []string)pb.Response  {
	if len(args)!=2 {
		shim.Error("输入的参数有误，请输入加密后的密文")
	}
	value := args[1]
	stub.PutState(args[0], []byte(value))
	return shim.Success(nil)

}


//获取IPFS加密的密文
func (recorda *RecordACC)seleInfo(stub shim.ChaincodeStubInterface,args []string)pb.Response  {
	if len(args)!=1 {
		shim.Error("输入的参数有误，请输入加密后的密文")
	}
	miwen, _ := stub.GetState(args[0])
	return shim.Success(miwen)
}


func (recorda *RecordACC) getHistoryForPatient(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	if len(args) < 1 {
		return shim.Error("参数错误，请输入一个参数")
	}
	Record_key := args[0]

	fmt.Printf("- start getHistory: %s\n", Record_key)

	resultsIterator, err := stub.GetHistoryForKey(Record_key)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}

		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"transactionID\":")
		buffer.WriteString("\"")
		buffer.WriteString(response.TxId)
		buffer.WriteString("\"")

		buffer.WriteString(", \"IPFS_crypt_hash\":\"")
	
		if response.IsDelete {
			buffer.WriteString("null")
		} else {
			buffer.WriteString(string(response.Value))
		}

		buffer.WriteString("\", \"transaction_Time\":")
		buffer.WriteString("\"")
		buffer.WriteString(time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String())
		buffer.WriteString("\"")

		buffer.WriteString(", \"isDeleted\":")
		buffer.WriteString("\"")
		buffer.WriteString(strconv.FormatBool(response.IsDelete))
		buffer.WriteString("\"")

		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("- getHistory returning:\n%s\n", buffer.String())

	return shim.Success(buffer.Bytes())
}





func main() {
	err := shim.Start(new (RecordACC))
	if err!=nil{
		fmt.Printf("创建Info链码失败：%s",err)
	}

}
