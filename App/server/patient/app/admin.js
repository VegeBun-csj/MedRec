
var express = require('express');
var router = express.Router();
var moment = require('moment');
var admin = require('../services/Admin');
var lunbo  = require('../services/Lunbo');
var crypto_rsa = require('../../Identity/crypto_rsa');
var identity = require('../../Identity/identity_utils');
var tx_op = require('../tx_chain/tx_op');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var CryptoJS = require("crypto-js");


const path = require('path');
const fs = require('fs');
const configpath= path.join(__dirname, '../../config.json');
const configJson = fs.readFileSync(configpath,'utf-8');
const config = JSON.parse(configJson);
const password = config.dbpassword;
const database = config.database;


var connection = mysql.createConnection({
	host: "localhost",
	user: "root",
	password: password,
	database: database
});

router.get('/',function(req,res)
{

	res.render('index.ejs');

})

router.get('/lunbo',function(req,res)
{
	var lunbo_id = req.query.lunbo_id;
	console.log(lunbo_id);
	function selLunbo(lunbo_id, callback) {
			connection.query('SELECT *  FROM lunbo WHERE lunbo_id = ?', [lunbo_id], function (err, result) {
				if (err)
					callback(err, null);
				else
					callback(null, [result[0]]);

			});

		}
		//call Fn for db query with callback
		selLunbo(lunbo_id, function (err, data) {
			if (err) {
				// error handling code goes here
				console.log("ERROR : ", err);
			} else {
				
				console.log(data[0]);

				res.render('lunbo.ejs',{lunbo: data[0]});

			}

		});
	

})


router.get('/test',function(req,res)
{


// Encrypt
	var ciphertext = CryptoJS.AES.encrypt('123456', 'secret key 123').toString();

	console.log('密文'+ciphertext);
// Decrypt
	var bytes  = CryptoJS.AES.decrypt(ciphertext, 'secret key 123');
	var originalText = bytes.toString(CryptoJS.enc.Utf8);
	
	console.log(originalText); // 'my message'
	
})


router.get('/goLogin',function (req,res,next) {

    // res.send('main-user');
    res.render('login.ejs');
});

//跳转注册
router.get('/goRegister', async function (req, res) {
    await identity.enrollAdmin();
    res.render('register.ejs'); // load the login.ejs file
});
//注册
router.post('/register', async function (req, res) {

    var username = req.body.username;
    var password_chushi = req.body.password;
    var work = req.body.work;
	var password = CryptoJS.AES.encrypt(password_chushi, 'secret key 123').toString();
    console.log(work);
	/*	var success={
			code:'200',
			message:'成功'
	
			};
		var fail={
				code:'500',
				message:'收藏中已有'
		
				};*/
    try {
		
			var result1 = await identity.checkUser(username);
			if(result1===false){
		//user exist
					var result = await identity.registerUser(username);
					if (result === true) {  //判断是否存在已注册的用户
           	 //生成公私钥对
						var res1 = await crypto_rsa.generator(username);
						console.log('生成公私钥');
						console.log(res1);
						if (res1 === true) {   //如果生成了公私钥对   这里因为生成的公私钥需要时间，所以设置了一个定时器，不然执行太快下面读取不到
							setTimeout(async () => {
								await crypto_rsa.getPubkey(username).then(pubkey => {
								console.log('获取公钥');
								console.log(pubkey.toString());
								setTimeout(async () => {
									console.log(`${username}的RSA公钥是${pubkey}`);
									await tx_op.invokeTx(username,'information', false, 'addInfo', pubkey)
         	                   //从本地提取公钥(字符串)，准备上链（此处只需要对公钥上链，上传者的身份，已经在链码中处理）
	
								}, 2000)
							})
	
							}, 2000)
	
						}
			   
			     admin.addPeople(username,password,work,function(err,results){
				if(err)
				{
					console.log(err);
				
				}
				res.render('login.ejs');
				});
			   
        	} else if (result === false) {

				res.render('register.ejs');
				
        	}

	}else if(result1===true){

	//user is not exist
			
			admin.selpatient(username,function(err,patient)
			{
				console.log(patient.pusername);
				admin.addPeople(patient.pusername,patient.ppassword,work,function(err,results){
				if(err)
				{
					console.log(err);
				
				}
				
					res.render('login.ejs');


				});
				
			})
	
	
	
		/*	*/
        
	

	}
  

    } catch (error) {
        console.log(error);
    }
	
   
});

/**
 * 注销
 */
router.get('/logout',function (req,res,next) {

    res.render('login.ejs');

})


/**
 * 登录
 */
router.post('/login', async function (req,res,next) {

    var username = req.body.username;
    var password = req.body.password;
    var work = req.body.work;

    await identity.checkUser(username).then(async (exist) => {
        console.log(exist);
        if (exist) {
			
			admin.selpatient2(username,work,function(err,patient)
			{
				console.log(patient.pusername);
				console.log('mima:'+patient.ppassword);
				var bytes  = CryptoJS.AES.decrypt(patient.ppassword, 'secret key 123');
				var originalpassword = bytes.toString(CryptoJS.enc.Utf8);
				if(originalpassword === password && username === patient.pusername)
				{
					res.render('patientDetail.ejs', {
													patient: patient
											})
				}
								
			})
	
        }
        else {
         			res.render('login.ejs')
        }
    })

});
router.get('/goIndex',function (req,res,next) {

   res.render('index.ejs');

});



module.exports = router;
