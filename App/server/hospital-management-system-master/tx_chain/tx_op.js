'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');
const fs = require('fs');
const configpath= path.join(__dirname, '../config.json');
const configJson = fs.readFileSync(configpath,'utf-8');
const config = JSON.parse(configJson);
const gatewayDiscovery = config.gatewayDiscovery;
const connection = config.connection_file;
const ccpPath = path.resolve(__dirname,'..','..','..',`../MedNet/${connection}`);
const walletName = config.walletName;
const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
const ccp = JSON.parse(ccpJSON);
const walletPath = path.join(__dirname,'..','..','Identity',walletName);
const wallet = new FileSystemWallet(walletPath);


//使用的用户，通道名，链码名，是否查询，方法名，参数列表
exports.invokeTx=async(username,chaincodeName,isquery,funcName,...args)=>{
    try {
        const gateway = new Gateway;
        const userExists = await wallet.exists(username);
		console.log(userExists);
        if (!userExists) {
                console.log(`An identity for the user ${username} does not exist in the wallet`);
                console.log('Run the registerUser.js application before retrying');
                return;
        }
        await gateway.connect(ccp,{wallet,identity:username,discovery:gatewayDiscovery})
        const network = await gateway.getNetwork('commonchannel');
        const contract = await network.getContract(chaincodeName);

        console.log(`=======>>>>>>>> start Tx <<<<<<<===========`);
        console.log(`isquery:${isquery} , functionName is :${funcName}, arguments is ${args}`);

        if(isquery===true){
            console.log('start query');
            if(args){
                //1.查询指定的键的值(selectByxxxx)，string类型
                let response = await contract.evaluateTransaction(funcName,...args)
                console.log(`Transaction ${funcName} with args ${args} has been evaluated`);
                console.log(`查询结果是${response}`);
                gateway.disconnect();
                return response;
            }else{
                //2.查询所有的值（直接调用selectAll方法，无需传入查询参数）
                let response = await contract.evaluateTransaction(funcName)
                console.log(`Transaction ${funcName}  has been evaluated`);
                console.log(`查询结果是${response}`);
                gateway.disconnect();
                return response;
            }

        }else{
            console.log('start invoke transaction');
            if(args){
                //3.提交交易（增加，删除）string类型
                    await contract.submitTransaction(funcName,...args);
                    console.log(`Transaction ${funcName} with args ${args} has been submit`);
                    gateway.disconnect();
                
            }else{
                //4.    
                await contract.submitTransaction(funcName);
                console.log(`Transaction ${funcName}  has been submit`);
                gateway.disconnect();
            }
        }
    
    } catch(err){
        console.error(`Failed to submit transaction: ${err}`);
    }
}