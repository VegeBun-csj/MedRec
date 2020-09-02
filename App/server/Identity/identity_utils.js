'use strict';
/* 
*创建admin user 
 创建普通 user
 登陆的用户检测
*/
const FabricCAServices = require('fabric-ca-client');
const { FileSystemWallet, X509WalletMixin, Gateway } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const configPath = path.join(__dirname, '../patient/config.json');
const configJSON = fs.readFileSync(configPath, 'utf8');
const config = JSON.parse(configJSON);
const AdminUser = config.AdminUser;
const orgMSPID = config.orgMSPID;
const admin = config.Admin;
const adminpwd = config.AdminSecret;
const walletName = config.walletName;
const gatewayDiscovery = config.gatewayDiscovery;
const connection = config.connection_file
const ccpPath = path.resolve(__dirname,'..','..',`../MedNet/${connection}`);
const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
const ccp = JSON.parse(ccpJSON);
const walletPath = path.join(__dirname, walletName);
const wallet = new FileSystemWallet(walletPath);

//管理员注册，这个方法在整个系统中只有注册超级管理员的时候才会调用，在我们的项目中只需要调用 一次即可
//后面的用户注册操作，都是基于这个管理员进行的
exports.enrollAdmin = async()=> {
    try {
	//向ca服务器注册管理员
        const caInfo = ccp.certificateAuthorities['ca.org1.medrec.com'];
        const caTLSCACerts = caInfo.tlsCACerts.pem;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);
        console.log(`Wallet path: ${walletPath}`);
	
        const adminExists = await wallet.exists(AdminUser);
        if (adminExists) {
            console.log('An identity for the admin user "admin" already exists in the wallet');
            return;
        }
	 // 向ca服务器注册管理员,并将从服务器获得的身份证书导入到wallet.
        const enrollment = await ca.enroll({ enrollmentID: admin, enrollmentSecret: adminpwd });
        const identity = X509WalletMixin.createIdentity(orgMSPID, enrollment.certificate, enrollment.key.toBytes());
	//并将从服务器获得的身份证书导入到wallet.
   	 await wallet.import(AdminUser, identity);
        console.log(`Successfully enrolled admin user "${AdminUser}" and imported it into the wallet`);

    } catch (error) {
        console.error(`Failed to enroll admin user "admin": ${error}`);
        // process.exit(1);
        return false;
    }
}


//username is string
exports.registerUser= async(userName)=>{
    try {
      console.log(`Wallet path: ${walletPath}`);
	//检查是否已经注册了
      const userExists = await wallet.exists(userName);
      if (userExists) {
        console.log(`An identity for the user ${userName} already exists in the wallet`);     
      }
	//检查是否已经有超级管理员了
      console.log(`scan admin user :${AdminUser}`);
      const adminExists = await wallet.exists(AdminUser);
      if (!adminExists) {
        console.log(`An identity for the admin user ${AdminUser} does not exist in the wallet`);
        console.log('Run the enrollAdmin function before retrying');
        return false;
      }

 	// 创建一个用于连接peer节点的网关
      const gateway = new Gateway();
      await gateway.connect(ccp, { wallet, identity: AdminUser, discovery: gatewayDiscovery });
  	// 创建一个用于与ca服务器交互的ca客户端对象
      const ca = gateway.getClient().getCertificateAuthority();
      const adminIdentity = gateway.getCurrentIdentity();

      console.log(`AdminIdentity: ${adminIdentity}`);
  	// 注册用户到ca服务器，并将从ca服务器获得的身份信息导入到wallet文件夹.
      const secret = await ca.register({ affiliation: 'org1.department1', enrollmentID: userName, role: 'client' }, adminIdentity);
      const enrollment = await ca.enroll({ enrollmentID: userName, enrollmentSecret: secret});
      const userIdentity = X509WalletMixin.createIdentity(orgMSPID, enrollment.certificate, enrollment.key.toBytes());
      wallet.import(userName, userIdentity);
      console.log(`Successfully registered user  ${userName}  and imported it into the wallet`);
      return true;
    } catch (error) {
      console.error(`Failed to register user  ${userName} : ${error}`);
      // process.exit(1);
      return false;
    }
  }



  //检测是否存在该用户（用于注册过的用户进行登陆时的验证）,返回为boolen
exports.checkUser=async(userName)=>{
    try {
      console.log(`Wallet path: ${walletPath}`);
      const userExists = await wallet.exists(userName);
      if (userExists) {
        console.log(`An identity for the user ${userName} already exists in the wallet`);
        return true;
      }else{
        console.log('该用户未注册');
        return false;
      }
    } catch (error) {
        console.log(`member user examin failed with ${error}`);
        return false;
    }
}

