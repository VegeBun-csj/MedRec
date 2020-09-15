
var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var bodyParser = require('body-parser');
var medicinelist = require('../services/MedicineList');
var orders = require('../services/orders');
var crypto_rsa = require('../../Identity/crypto_rsa');
var identity = require('../../Identity/identity_utils');
var tx_op = require('../tx_chain/tx_op');
var patientPay = require('../services/patientPay');


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

	//侧面板
	router.get('/info',function (req,res,next) {

		res.render('info.ejs');
	})

	//我的信息
	router.get('/myDetail',function (req,res,next) {


		var pid  = req.query.pid;
		var hid = req.query.hid;
		console.log("xxxxxx"+pid+'aaaaaa'+hid);

		function patientlogin(pid, callback) {
			connection.query('SELECT *  FROM patient WHERE pid = ?', [pid], function (err, result) {
				if (err)
					callback(err, null);
				else
					callback(null, [result[0]]);

			});

		}
		//call Fn for db query with callback
		patientlogin(pid, function (err, data) {
			if (err) {
				// error handling code goes here
				console.log("ERROR : ", err);
			} else {
				
				console.log(data[0]);

				res.render('patientDetail.ejs',{patient: data[0]});

			}

		});

	});

	router.post('/saveMyInfo',function (req,res,next) {

		var pid = req.body.pid;
		var pname = req.body.pname;
		var pusername = req.body.pusername;
		var age = req.body.age;
		var sex = req.body.sex;
		var telephone = req.body.telephone;
		var icd = req.body.icd;
		console.log(pname);
		console.log(pid);
		connection.query('UPDATE patient SET pname=?,age=?,sex=?,telephone=?,icd=? WHERE pid=?;',[pname,age,sex,telephone,icd,pid],function (err,result) {

			if(err)
			{

			}else {
				function backUpdateInfo(pid, callback) {
					connection.query('SELECT *  FROM patient WHERE pid = ?', [pid], function (err, result) {
						if (err)
							callback(err, null);
						else
							callback(null, [result[0]]);

					});

				}
				backUpdateInfo(pid, function (err, data) {
					if (err) {
						// error handling code goes here
						console.log("ERROR : ", err);
					} else {
						
						console.log(data[0]);
						res.render('patientDetail.ejs',{patient: data[0]});

					}

				});
			}

		})



	});



/**
 * 跳转到选择科室页面
 */
router.get('/selectKeshi',function (req,res,next) {
		var pid  = req.query.pid;
		var hid = req.query.hid;
		console.log('医院id '+hid);
    	var json0;
    	var json1;

		function backkeshiInfo_0(pid, callback) {

			connection.query('SELECT *  FROM office where officeType=0',function (err, result) {
				if (err)
					callback(err, null);
				else
					callback(null, result);

			});

		}
		backkeshiInfo_0(pid, function (err, data) {
			if (err) {
				console.log("ERROR : ", err);
			} else {
				var dataString = JSON.stringify(data);
				 json0 = JSON.parse(dataString);
				console.log(json0);

			}

		});
		function backkeshiInfo_1(pid, callback) {
			connection.query('SELECT *  FROM office where officeType=1',function (err, result) {
				if (err)
					callback(err, null);
				else
					callback(null, result);

			});

		}
		backkeshiInfo_1(pid, function (err, data) {
			if (err) {
				console.log("ERROR : ", err);
			} else {
				var dataString = JSON.stringify(data);
				json1 = JSON.parse(dataString);
				console.log(json1);
				res.render('patientSelectKeshi.ejs',
					{   waike:json1,
						neike:json0,
						pid:pid,
						hid:hid
					});

			}

		});
	});
//选择科室
router.get('/intoKeshi',function (req,res,next) {

	var pid  = req.query.pid;
	var hid = req.query.hid;
	var officeId = req.query.officeId;
	console.log(pid+" "+hid+" "+officeId);

	function patient(pid, callback) {
		connection.query('SELECT *  FROM patient WHERE pid = ?', [pid], function (err, result) {
			if (err)
				callback(err, null);
			else
				callback(null, result);

		});

	}
	//call Fn for db query with callback
	patient(pid, function (err, data) {
		if (err) {
			// error handling code goes here
			console.log("ERROR : ", err);
		} else {
			var dataString = JSON.stringify(data);
			var json1 = JSON.parse(dataString);
			console.log(json1);

			res.render('patientTellSymptom.ejs',
				{   patient:json1,
					pid:pid,
					hid:hid,
					officeId : officeId
				});

		}

	});

});
//提交症状
router.post('/writeSymptom',function (req,res,next) {

	var pid = req.body.pid;
	var hid = req.body.hid;
	var officeId = req.body.officeId;
	var description = req.body.description;
	var allergic = req.body.allergic;
	var bdate = new Date().toISOString().slice(0, 19).replace('T', ' ');
	console.log(bdate);
	connection.query('INSERT INTO relationship (pid,hid,officeId,description,allergic,bdate) VALUES (?,?,?,?,?,?)',[pid,hid,officeId,description,allergic,bdate],function (err,rows,fields) {
	if(err)
	{
		console.log(err);
		return;
	}
	var success={
		code:'200',
		message:'成功'

		};
		res.json(success);

		return;
	})

});


//返回药品列表
router.get('/yaofang',function(req,res,next)
{
	var pid  = req.query.pid;
	var hid = req.query.hid;

	medicinelist.getMedicineList(pid,hid,function(err,medicines)
    {
        //JSON.stringify(medicines);
        console.log(medicines[0].m_name);
	   res.render('patientMedicineShop.ejs',
	   {
		   medicines:medicines,
		   pid:pid,
		   hid:hid
		});

    });


});


router.post('/searchMedicine',function(req,res)
{
	var hid = req.body.hid;
	var pid = req.body.pid;
	var type = req.body.type;
	console.log(type);
	var m_type;
	var m_name;
	var name = req.body.m_name;
	console.log(name);
	if(type === '1')
	{
		m_type = name;
		medicinelist.searchMedicineByType(hid,m_type,function(err,medicines)
		{
			console.log(medicines[0]);
			res.render('patientMedicineShop.ejs',
			{
				medicines:medicines,
				pid:pid,
				hid:hid
			});
			
		});
		
	}else{
		
		m_name = name;
		
		medicinelist.searchMedicineByName(hid,m_name,function(err,medicines)
		{
			console.log(medicines[0]);
			res.render('patientMedicineShop.ejs',
			{
				medicines:medicines,
				pid:pid,
				hid:hid
			});
			
		});
		
		
		
	}
	
});

//查看药品细节
router.get('/medicineDetail',function(req,res,next){

	var pid = req.query.pid;
	var mid = req.query.mid;
	var hid = req.query.hid;

	medicinelist.getMedicineDetail(mid,function(err,medicine)
	{

		if(err)
		{
			console.log(err);
		}
		console.log("m_name"+medicine[0].m_name);
		res.render('patientMedicineDetail.ejs',
		{
			medicine:medicine[0],
			pid:pid,
			hid:hid
		}
		
		);

	});
});
//添加药品到收藏
router.post('/addToWish',function(req,res)
{
	var pid = req.body.pid;
	var mid = req.body.mid;
	console.log(pid);
	medicinelist.addToWishList(pid,mid,function(status)
	{
	
		var success={
			code:'200',
			message:'成功'
	
			};
		var fail={
				code:'500',
				message:'收藏中已有'
		
				};
		if(status===0)
		{
			res.json(fail);
		}else{
			res.json(success);
		}
			
	
			return;

	})

})
//药品下单
router.post('/xiadan',function(req,res){

	var order_count = req.body.order_count;
	var order_price = req.body.order_price;
	var hid = req.body.hid;
	var pid = req.body.pid;
	var mid = req.body.mid;
	var m_num = req.body.m_num;
	orders.xiadan(order_count,order_price,hid,pid,mid,function(status)
	{
		var success={
			code:'200',
			message:'成功'
	
			};
		var fail={
				code:'500',
				message:'失败'
		
				};
		if(status===0)
		{
			res.json(fail);
		}else{

			m_num = m_num-order_count;
			medicinelist.updateKucun(mid,m_num,function(status)
			{
				if(status === 1){
					res.json(success);
				}
			});


			
		}
			
	
			return;
	});

})
//查看订单
router.get('/myOrders',function(req,res)
{

	var pid = req.query.pid;
	var hid =req.query.hid;
	function getOrdersList(pid,hid, callback) {
		connection.query('SELECT m.m_name,m.mid,o.order_price,o.order_date,o.order_count,o.oid,o.order_code,o.order_status,o.hid FROM medicine m, orders o WHERE m.mid = o.mid and o.pid=? and o.hid=?;', [pid,hid], function (err, result) {
			
			if (err)
				callback(err, null);
			else
				callback(null, [result]);

		});

	}
	//call Fn for db query with callback
	getOrdersList(pid,hid, function (err, data) {
		if (err) {
			// error handling code goes here
			console.log("ERROR : ", err);
		} else {
			
			var dataString = JSON.stringify(data[0]);
				json1 = JSON.parse(dataString);
				console.log(json1);
		
			res.render('patientOrders.ejs',
		{
			ordersList:json1,
			pid:pid,
			hid:hid
		}
		
		);
		}

	});

})
//到收藏
router.get('/wishList',function(req,res,next)
{

	var pid = req.query.pid;
	var hid = req.query.hid;
	console.log(pid+"ccccccc");

	function getwishList(pid,hid, callback) {
		connection.query('SELECT m.mid,m.m_name,m.m_price,m.m_picture,w.wish_id FROM medicine m, wishlist w WHERE m.mid = w.mid and w.pid=? and hid=?;', [pid,hid], function (err, result) {
			if (err)
				callback(err, null);
			else
				callback(null, [result]);

		});

	}
	//call Fn for db query with callback
	getwishList(pid,hid, function (err, data) {
		if (err) {
			// error handling code goes here
			console.log("ERROR : ", err);
		} else {
			
			var dataString = JSON.stringify(data[0]);
				json1 = JSON.parse(dataString);
				console.log(json1);
		
			res.render('patientWishlist.ejs',
		{
			wish_medicine:json1,
			pid:pid,
			hid:hid
		}
		
		);
		}

	});




});
//删除收藏
router.get('/delWish',function(req,res,next)
{
	var strs = req.query.tag;
	var arr = strs.split(",");      
	var pid  = req.query.pid;
	var hid = req.query.hid;
	for (let i = 0; i < arr.length; i++) {
		
		const wish_id = arr[i];
		medicinelist.removeWish(wish_id,function(err)
		{

			if(err)
			{
				console.log(err);
			}
		
			getwishList(pid, function (err, data) {
				if (err) {
					// error handling code goes here
					console.log("ERROR : ", err);
				} else {
					
					var dataString = JSON.stringify(data[0]);
						json1 = JSON.parse(dataString);
						console.log(json1);
				
					res.render('patientWishlist.ejs',
				{
					wish_medicine:json1,
					pid:pid,
					hid:hid
				}
				
				);
				}
		
			});
			function getwishList(pid, callback) {
				connection.query('SELECT m.mid,m.m_name,m.m_price,m.m_picture,w.wish_id FROM medicine m, wishlist w WHERE m.mid = w.mid and w.pid=?;', [pid], function (err, result) {
					if (err)
						callback(err, null);
					else
						callback(null, [result]);
		
				});
		
			}
		});
		
	}
	


});
//返回余额
router.post('/checkMoney',function(req,res)
{

	var pid = req.body.pid;
	getyu_e(pid, function (err, data) {
		if (err) {
			// error handling code goes here
			console.log("ERROR : ", err);
		} else {
			
			var dataString = JSON.stringify(data[0]);
				json1 = JSON.parse(dataString);
				console.log(json1[0].yu_e);

				var success={
					code:'200',
					message:'成功',
					data: json1[0].yu_e
			
					};
				var fail={
						code:'500',
						message:'失败'
				
						};
					res.json(success);
					
			
					return;
		// 	res.render('patientWishlist.ejs',
		// {
		// 	wish_medicine:json1,
		// 	pid:pid
		// }
		
		// );
		}

	});
	function getyu_e(pid, callback) {
		connection.query('SELECT yu_e FROM patient_wallet where pid=?;', [pid], function (err, result) {
			if (err)
				callback(err, null);
			else
				callback(null, [result]);

		});

	}



});

router.post('/goPay',function(req,res)
{

	console.log('aaaaaaaaaaaaaaaaaaaaaaaaa');
	var pid = req.body.pid;
	var hid = req.body.hid;
	var order_price = req.body.order_price;
	var yu_e = req.body.yu_e;
	var oid = req.body.oid;
	var mid = req.body.mid;
	//var order_count = req.body.order_count;
	yu_e = yu_e-order_price;
	console.log(yu_e+"xxxxxxx");
	var password =req.body.password;

	var success={
		code:'200',
		message:'成功',
		

		};
	var password_wrong={
			code:'500',
			message:'密码错误，请重新输入！'
	
			};


	patientPay.minusMoney(pid,yu_e,password,function(status)
	{
		
		if(status === 0)
		{
			patientPay.HospitaladdMoney(hid,order_price,function(status)
			{
				if(status === 2)
				{
					patientPay.updateOrdersStatus_pay(oid,function(status)
					{
						if(status === 3)
						{

							res.json(success);

						}


					});

				}


			});
		}
		else{

			res.json(password_wrong);

		}

		return;

	});





});

router.post('/ordersCancel',function(req,res)
{
	var oid = req.body.oid;
	var order_count = req.body.order_count;
	var mid = req.body.mid;
	var success={
		code:'200',
		message:'成功',
		

		};
	var wrong={
			code:'500',
			message:'密码错误，请重新输入！'
	
			};
	patientPay.updateOrdersStatus_cancel(oid,function(status)
	{
		if(status === 0)
		{

			patientPay.updateMedicine_num(mid,order_count,function(status)
			{

				if(status === 1)
				{

					res.json(success);
				}


			})
		}
		else{


			res.json(wrong);
		}

	});



   return;


})

router.post('/searchOrders',function(req,res)
{
	var pid = req.body.pid;
	var m_name = req.body.m_name;
	var hid = req.body.hid;
	getyu_e(pid, function (err, data) {
		if (err) {
			// error handling code goes here
			console.log("ERROR : ", err);
		} else {
			
			var dataString = JSON.stringify(data[0]);
				json1 = JSON.parse(dataString);
				console.log(json1[0]);

			
				
			res.render('patientOrders.ejs',
		{
			ordersList:json1,
			pid:pid,
			hid:hid
		}
		
		);
		}

	});
	function getyu_e(pid, callback) {
		connection.query('SELECT m.m_name,m.mid,o.order_price,o.order_date,o.order_count,o.oid,o.order_code,o.order_status,o.hid FROM medicine m, orders o WHERE m.mid = o.mid and m.m_name=?;', [m_name], function (err, result) {
			if (err)
				callback(err, null);
			else
				callback(null, [result]);

		});

	}



});


router.get('/giveAuthority',function(req,res)
{
	var pid  = req.query.pid;
	var hid = req.query.hid;
	res.render('patientManage.ejs',{pid:pid,hid:hid});



});


//查看链上就诊信息
router.post('/authority', async function(req,res)
{
	
    console.log('查看链上就诊信息......');
   
    var hospital = req.body.hname;
    var idnum = req.body.icd;
    var pid = req.body.pid;
	var hid = req.body.hid;
    // tx_op.invokeTx('csj')
    var pusername = req.body.pusername;
    console.log(`正在操作的用户是`+pusername);
    //授权的时候的键名是患者-身份证号-医院（跟上传病历是相反的）
    let key = `${hospital}-${pusername}-${idnum}`;
    //从链上获取hospital的公钥
    let res1 =  await tx_op.invokeTx(pusername,'recordpa',true,'getHistoryForPatient',key);
    console.log(`从链上查询的buffer类型的历史记录是${res}`);
    let result = res1.toString();
    console.log(`转换为json对象之后为${res}`);
    if (Object.keys(result).length != 0) {
        let dataobj =  JSON.parse(result)   
        console.log(dataobj instanceof Array);
        console.log(`-----------开始解密历史信息-----------`);
        for (const iterator of dataobj) {
            let hash =  iterator.IPFS_crypt_hash;
            let mingwen = await crypto_rsa.decrypt(pusername, hash.toString());
            console.log(`明文是${mingwen.toString()}`);
            iterator.IPFS_crypt_hash = mingwen.toString();
        }
        await res.render('showRecord.ejs',{
            dataobj:dataobj,
			pid:pid,
			hid:hid
        }) 
    } else{
		
		res.render('patientManage.ejs',{pid:pid,hid:hid});
		
	}

})
//跳转到授权界面
router.get('/toAuthority',function(req,res)
{
	var ipfs = req.query.ipfs;
	var pid = req.query.pid;
	var hid = req.query.hid;
	console.log("xxxxxxxxxxxxxxxxxx"+ipfs);
	
	res.render('toAuthority.ejs',{pid:pid,ipfs:ipfs,hid:hid});
		
})


router.post('/patientGiveAuthority',async function(req,res)
{
	
	var pid = req.body.pid;
	var ipfs= req.body.ipfs;
	var idnum = req.body.icd;
	var patient = req.body.pusername;
	var hospital = req.body.hname;
	var hid = req.body.hid;
	
	 console.log(`正在操作的用户是${patient}`);
    //授权的时候的键名是患者-身份证号-医院（跟医生上传病历是相反的）
    let key = `${patient}-${idnum}-${hospital}`;
    //从链上获取doctor的公钥
    let pubkey = await tx_op.invokeTx(patient, 'information', true, 'seleInfo', hospital)
    //通过doctor的公钥对IPFShash进行加密，得到密文
    console.log(`获取的医生的公钥是${pubkey}`);
    await crypto_rsa.encrypt(pubkey, ipfs).then(async miwen => {
        //这里的密文是string类型的数据
        console.log(`加密后的密文时${miwen}`);
        await tx_op.invokeTx(patient, 'recordpa', false, 'addRecord', key, miwen).then(()=>{
           console.log('授权给'+hospital+'成功');
        })
    });
   // console.log(`resp的状态是${resp.data}`);
    //ctx.body = JSON.stringify(resp);
	
	res.render('patientManage.ejs',{pid:pid,hid:hid});
    //将密文上链
    // await ctx.render('success')
	
	
})






router.get('/mybinli',function(req,res)
{


	var pid = req.query.pid;
	var hid = req.query.hid;
	
getbinli(pid,hid, function (err, data) {
	if (err) {
		// error handling code goes here
		console.log("ERROR : ", err);
	} else {
		
		var dataString = JSON.stringify(data[0]);
			json1 = JSON.parse(dataString);
			console.log(json1);


		
			
		res.render('patient_bl_list.ejs',
	{
		 binli:json1,
		pid:pid,
		hid:hid
	}
	
	);
	}

});
function getbinli(pid,hid, callback) {
	connection.query('SELECT  p.pname,h.hname,r.bdate,r.description,s.symptomName,o.officeName,m.m_name FROM patient p,hospital h,relationship r,symptom s,office o,medicine m WHERE p.pid=r.pid AND h.hid=r.hid AND o.officeId=r.officeId AND s.symptomId = r.symptomId  AND r.mid = m.mid and r.pid=? and r.hid =?;',[pid,hid], function (err, result) {
		if (err)
			callback(err, null);
		else
			callback(null, [result]);

	});

}


});


router.get('/myWallet',function(req,res)
{
	var pid = req.query.pid;
	var hid = req.query.hid;
	console.log(pid);
	patientPay.isHaveWallet(pid,function(status)
	{

		console.log('status: '+status);
		if(status === 1)
		{
			
			res.render("patientWallet.ejs",{pid:pid,hid:hid});
		}
		else{

			patientPay.getWalletDetail(pid,function(patient_wallet)
			{


				var dataString = JSON.stringify(patient_wallet[0]);
	
				json1 = JSON.parse(dataString);
				console.log(json1);
				
				res.render('patientWalletInfo.ejs',{patient_wallet:json1,pid:pid,hid:hid});


			});
		

		}


	});





});

router.post('/registerWallet',function(req,res)
{
	console.log('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
	var pid = req.body.pid;
	var p_wallet_name = req.body.p_wallet_name;
	var password = req.body.password;
	var success={
		code:'200',
		message:'成功',
	
		};
	var wrong={
			code:'500',
			message:'密码错误，请重新输入！'
	
			};
	patientPay.registerWallet(pid,p_wallet_name,password,function(status)
	{
		if(status === 1)
		{
			res.json(success);


		}else{
			res.json(wrong);
		}

	});

	return;



});

router.post('/chongzhi',function(req,res)
{
	var pid = req.body.pid;
	var password = req.body.password;
	var amount = req.body.amount;
	var success={
		code:'200',
		message:'成功',
	
		};
	var wrong={
			code:'500',
			message:'密码错误，请重新输入！'
	
			};
	patientPay.chongzhi(pid,amount,password,function(status)
	{
		if(status ===0)
		{
			res.json(wrong);

		}
		else{

			res.json(success);
		}


	});
	return;

});

router.post('/changeWalletPassword',function(req,res)
{
	var pid = req.body.pid;
	var newPassword = req.body.newPassword;

	var oldpassword = req.body.oldpassword;
	var success={
		code:'200',
		message:'成功',
	
		};
	var wrong={
			code:'500',
			message:'密码错误，请重新输入！'
	
			};
	patientPay.changeWalletPassword(pid,oldpassword,newPassword,function(status)
	{
		if(status === 0)
		{
			res.json(wrong);

		}
		else{

			res.jsons(success);
		}


	});

	return;




});

module.exports = router;
