const NodeRSA = require('node-rsa')
const fs = require('fs')



//生成rsa公私钥对(根据传入的用户，生成在当前的对应文件夹下面)
exports.generator = async (username) => {
    try {
        let key = new NodeRSA({ b: 512 })
        key.setOptions({ encryptionScheme: 'pkcs1' })
        let privatePem = key.exportKey('pkcs1-private-pem')
        let publicPem = key.exportKey('pkcs1-public-pem')
        let exist = await fs.exists(__dirname + `/wallet-Org1/${username}/public.pem`)
        if (!exist) {
            fs.writeFile(__dirname + `/wallet-Org1/${username}/public.pem`, publicPem, (err) => {
                if (err) throw err
                console.log(`${username}的rsa公钥已保存！`)
            })
            fs.writeFile(__dirname + `/wallet-Org1/${username}/private.pem`, privatePem, (err) => {
                if (err) throw err
                console.log(`${username}的rsa私钥已保存！`)
            })
            return true;
        } else {
            console.log('已经存在公私钥对');
            return false;
        }
    } catch (error) {
        console.log(error);
    }

}


//获取本地的公钥，用于一开始登陆时上传
exports.getPubkey = async (username) => {
    let publicKeyStr = fs.readFileSync(__dirname + `/wallet-Org1/${username}/public.pem`);
    //公钥
    return publicKeyStr.toString('utf-8');
}


//获取本地的私钥，用于解密从链上获取的明文数据
exports.getPrikey = async (username) => {
    let privateKeyStr = fs.readFileSync(__dirname + `/wallet-Org1/${username}/private.pem`);
    //私钥
    return privateKeyStr;
}



//返回的是Buffer类型的密文
exports.encrypt = async (publicKeyStr, msg) => {
    let pubKey = new NodeRSA(publicKeyStr);
     let encryptStr = pubKey.encrypt(msg, 'base64');
     console.log(encryptStr.toString('utf-8'));
    return encryptStr;
}



//传入的miwen必须是buffer类型的(也就是加密时返回的buffer类型的encryptStr)
//    返回的是string类型的明文数据
exports.decrypt = async (username, miwen) => {
    let privateKeyStr = fs.readFileSync(__dirname + `/wallet-Org1/${username}/private.pem`, 'utf-8');
    console.log(privateKeyStr);  
    let priKey  = new NodeRSA(privateKeyStr);
    let decryptStr = priKey.decrypt(miwen, 'utf8');
    return decryptStr;
}



