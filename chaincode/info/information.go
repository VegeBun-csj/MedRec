package main

import (
	"bytes"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

/*type Info struct {
	RsaPubkey string `json:"rsa_pubkey"`
	EccPubkey string `json:"ecc_pubkey"`
}
*/

//该链码运行在commmonchannel上
type InfoCC struct {

}

func (info *InfoCC)Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

func (info *InfoCC) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fn,args:= stub.GetFunctionAndParameters()
	fmt.Printf("方法为:%s  参数为%s \n",fn,args)
	if fn =="addInfo"{
		return info.addInfo(stub,args)
	}else if fn == "seleInfo"{
		return info.seleInfo(stub,args)
	}
	return shim.Error("请输入正确的方法名,usage:addInfo/seleInfo")
}


//该方法在左右用户的操作中只会调用一次，即用户登陆的时候
func (info *InfoCC)addInfo(stub shim.ChaincodeStubInterface,args []string)pb.Response  {
	if len(args)!=1{
		return shim.Error("参数错误，请输入一个代表公钥的参数")
	}
	//获取链码调用者的身份
	creatorByte,_:= stub.GetCreator()
	certStart := bytes.IndexAny(creatorByte, "-----BEGIN")
	if certStart == -1 {
		fmt.Errorf("No certificate found")
	}
	certText := creatorByte[certStart:]
	bl, _ := pem.Decode(certText)
	if bl == nil {
		fmt.Errorf("Could not decode the PEM structure")
	}

	cert, err := x509.ParseCertificate(bl.Bytes)
	if err != nil {
		fmt.Errorf("ParseCertificate failed")
	}
	//身份creator
	creator:=cert.Subject.CommonName

	stub.PutState(creator, []byte(args[0]))
	return shim.Success(nil)
}


//这是需要获取公钥进行加密时调用      或者第三方获取公钥进行验签时调用
func (info *InfoCC)seleInfo(stub shim.ChaincodeStubInterface,args []string)pb.Response  {
	if len(args)!=1{
		return shim.Error("参数错误，请输入一个userid以查询其公钥")
	}
	pubkey, err := stub.GetState(args[0])
	if err!=nil {
		return shim.Error("查询公钥错误")
	}
	if len(pubkey)==0{
		return shim.Error("没有该用户的公钥")
	}
	return shim.Success(pubkey)
}




func main() {
	err := shim.Start(new (InfoCC))
	if err!=nil{
		fmt.Printf("创建Info链码失败：%s",err)
	}

}

