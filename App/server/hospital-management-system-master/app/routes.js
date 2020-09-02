// app/routes.js
var did;
var nid;
var pid;
var wid;
var rid;
var g;
var bill_id;
var quantity;
var u_price;
var m_id;
var bingrenid;
var patientid;
var updateusername;
var hid;
var medid;
var mysql = require('mysql');
var officegen = require('officegen');
var multer = require('multer');
var upload = multer({dest:'uploads/'})
var fs = require('fs');
var docx = officegen('docx');//word

var crypto_rsa = require('../../Identity/crypto_rsa');
var identity = require('../../Identity/identity_utils');
var tx_op = require('../tx_chain/tx_op');
var ipfs = require('../../ipfs/ipfs_op');
var fileUpload = require('express-fileupload');


var mmedicine = null;
var hospitaluser =null;
var inp;
var addorders;
var orderid;
var newuser;
global.pid=1;
global.orderid=1;

var connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "louise",
  database: "bishe2"
});

module.exports = function(app, passport) {

	// =====================================
	// HOME PAGE (with login links) ========
	// =====================================
	//医生诊断页面（病人列表）调用relationship列表
	
	//app.use(fileUpload());
	
	app.use(fileUpload({
    useTempFiles : true,
    tempFileDir : '/home/songjian/go/src/github.com/hyperledger/MedRec/App/server/public/medicinePIc'
	}));
    app.get('/patient', function(req, res) {
        //connection.query('select * from bingren where tijian=2', function (err, rows) {
        //    //console.log(rows);
        //    res.render('id_prescription',{test:'patientlist' ,patient: rows} );
        //})
        if(req.user.user_type == 'hospital2'){
            hid = 2;
        }
        else if(req.user.user_type == 'hospital1'){
            hid = 1;
        }
        connection.query('select h.hname hname,r.rid rid,r.pid pid,r.hid hid,r.bdate bdate,r.description description,o.officeName officeName,p.pname pname from relationship r,office o,patient p,hospital h where r.hid = ? and r.officeId = o.officeId and p.pid=r.pid and r.hid=h.hid',hid, function (err, rows) {
            //console.log(rows);
            res.render('id_prescription',{test:'patientlist' ,patient: rows, datastring:''} );
        })
    });
  

    //首页
	app.get('/', function(req, res) {
        if(hospitaluser != null){
            connection.query("insert into hospital SET ? ", hospitaluser,function (err, rows){
            })
            hospitaluser = null;
        }//注册的时候同时插入hospital表和user表 插入hospital的hname和hpassword字段 插入user的user_type字段
        if(newuser != null){
            connection.query("select * from user where user_type = ?", newuser.user_type, function (err,row) {
                if(row[0] == null){
                    connection.query("INSERT INTO user SET ?", newuser, function (err,res) {
                    });
                    newuser = null;
                }
            });
        }
		//在首页运行时进行读取数据操作：patient表中patientid--->插入bingren表
		//var paientid;
		//connection.query("select * from patient",function (err,reslut) {
		//	reslut.forEach(function (row) {
		//		patientid = row.patientid;
        //        console.log(patientid);
		//		connection.query("select * from bingren where id=?",row.patientid,function(err,bingrenrows){
		//			if(bingrenrows[0]==null)
		//			{
		//				connection.query("insert into bingren (id) values(?)",row.patientid,function(err,rows){
        //                if (err) {
        //                    res.end('修改失败：' + err);
        //                } else {
        //                	//console.log(patientid);
        //                }
		//			})
		//			}
        //        })
		//	})
        //});
        res.render('index.ejs');
	});


	// =====================================
	// LOGIN ===============================
	// =====================================
	// show the login form
	app.get('/login', function(req, res) {
		// render the page and pass in any flash data if it exists
		res.render('signin', { message: req.flash('loginMessage') });
	});
	// process the login form
	app.post('/login', passport.authenticate('local-login', {
			successRedirect : '/profile', // redirect to the secure profile section
			failureRedirect : '/login', // redirect back to the signup page if there is an error
            failureFlash : true // allow flash messages
		}),
        function(req, res) {
            console.log("hello");
            if (req.body.remember) {
              req.session.cookie.maxAge = 1000 * 60 * 3;
            } else {
              req.session.cookie.expires = false;
            }
        res.redirect('/');
    });



	// =====================================
	// PROFILE SECTION =========================
	// =====================================
	// we will want this protected so you have to be logged in to visit
	// we will use route middleware to verify this (the isLoggedIn function)
    //其实这个没什么用，因为两个index调成一样了。
	app.get('/profile', isLoggedIn, function(req, res) {

		var yu_e;
		console.log(req.user+"xxxxxxxxxxxxxxxx");
        if(req.user.user_type == 'hospital2'){
		    hid = 2;
			
			 connection.query("select * from hospital_wallet where hid=" + hid, function (err, row_4) {
				
					yu_e = row_4[0].yu_e;
					console.log('yu_e'+yu_e);
			 });
			
			res.render('NurseIndex.ejs', {
				user : req.user,
				 yu_e:yu_e               
			});
		}
        else if(req.user.user_type == 'hospital1'){
            hid = 1;
			
			 connection.query("select * from hospital_wallet where hid=" + hid, function (err, row_5) {
				
					yu_e = row_5[0].yu_e;
					console.log('yu_e'+yu_e);
				
			 });
			res.render('DoctorIndex.ejs', {
				user : req.user,
				yu_e:yu_e
				
			});
		}
		
	});


	//11111111111111111111111111111111111111111111111111
	app.get('/watchthirdbinli',isLoggedIn,function(req,res)
	{
	    res.render('thirdselect',{hospital:req.user.user_type});	
          

	})
	
	//22222222222222222222222222222222222222222222222222	
	app.post('/thirdsele',isLoggedIn, async function(req,res)
	{
		  console.log(`进入第三方医院登陆界面`);
   		// let req = ctx.query;
			let resp = {};
    		let hospital = req.body.hospital;
			let patient = req.body.patient;
    		let idnum = req.body.idnum;
			//let user = ctx.cookies.get('userInfo')
   		// console.log(`cookie name is ${user}`);
   		 let key = `${patient}-${idnum}-${hospital}`;
    //医生通过这个授权的key获取链上的密文
	console.log('patient is '+patient);
	let res1 =  await tx_op.invokeTx(hospital,'recordpa',true,'getHistoryForPatient',key);
    console.log(`从链上查询的buffer类型的历史记录是${res}`);
    let result = res1.toString();
    console.log(`转换为json对象之后为${res}`);
    if (Object.keys(result).length != 0) {
        let dataobj =  JSON.parse(result)   
        console.log(dataobj instanceof Array);
        console.log(`-----------开始解密历史信息-----------`);
        for (const iterator of dataobj) {
            let hash =  iterator.IPFS_crypt_hash;
            let mingwen = await crypto_rsa.decrypt(hospital, hash.toString());
            console.log(`明文是${mingwen.toString()}`);
            iterator.IPFS_crypt_hash = mingwen.toString();
        }
		
		console.log(dataobj);
        await res.render('showRecord.ejs',{
            dataobj:dataobj
        }) 
    }


	})	






	//药房列表 显示medicine表
    app.get('/medicine', isLoggedIn, function(req, res){
        if(req.user.user_type == 'hospital2'){
            hid = 2;
        }
        else if(req.user.user_type == 'hospital1'){
            hid = 1;
        }
        if(mmedicine != null){
            connection.query("insert into medicine SET ? ", mmedicine,function (err, rows){
            })
            mmedicine = null;
        }
        connection.query('select * from medicine where hid = ?',hid, function (err, rows) {
        //connection.query('select * from medicine', function (err, rows) {
            //console.log(rows);
            res.render('medicine',{test:'patientlist' ,patient: rows, datastring:''} );
        })
    })
    //删除的post调用
    app.post('/medicine', isLoggedIn, function(req, res){
        if(req.user.user_type == 'hospital2'){
            hid = 2;
        }
        else if(req.user.user_type == 'hospital1'){
            hid = 1;
        }
        var deletemid = req.body.mid;
        connection.query("DELETE FROM medicine WHERE mid= ?", deletemid);
        res.redirect('/medicine');
    })
    //通过路由参数选择药的mid，通过药的mid调用对应行数据（查看具体药信息）
    app.get('/medicinedetail', isLoggedIn, function(req, res){
        if(req.user.user_type == 'hospital2'){
            hid = 2;
        }
        else if(req.user.user_type == 'hospital1'){
            hid = 1;
        }
        if(req.query.id) {
             medid = req.query.id;
        }
        connection.query('select * from medicine where hid = '+ hid +' and mid = '+ medid, function (err, rows) {
            //connection.query('select * from medicine', function (err, rows) {
            //console.log(rows);
            res.render('medicinedetail',{test:'patientlist' ,datas: rows, datastring:''} );
        })
    })
    //修改具体药信息
    app.post('/medicinedetail', isLoggedIn, function(req, res){
        if(req.user.user_type == 'hospital2'){
            hid = 2;
        }
        else if(req.user.user_type == 'hospital1'){
            hid = 1;
        }
        if(req.query.id) {
             medid = req.query.id;
        }
            mmedicine = {m_type: req.body.m_type,// m_hid: hid, m_mid: medid,
            m_name: req.body.m_name, m_num: req.body.m_num, m_price: req.body.m_price,
            m_status: req.body.m_status, m_picture: req.body.m_picture, m_gongneng: req.body.m_gongneng,
            m_guige: req.body.m_guige, m_yongfa: req.body.m_yongfa, m_buliangfanying: req.body.m_buliangfanying,
            m_youxiaoqi: req.body.m_youxiaoqi, m_producerName: req.body.m_producerName, m_producerAddress: req.body.m_producerAddress,
            m_wenhao: req.body.m_wenhao, m_chengfen: req.body.m_chengfen};
        connection.query("update medicine SET ? where mid = "+ medid, mmedicine);
        mmedicine = null;
        res.redirect('/medicine');
    })
    //跳转到增加药的页面
    app.get('/addmed', isLoggedIn, function(req, res){
        connection.query("select * from symptom", function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                res.render("addmed", {datas1:rows1});       //直接跳转
            }
        });
    })
    //使用post获得页面数据增加药
    app.post('/addmed', function(req, res){
		
		 var pic = req.files.m_pic;
			var tmpfile = pic.tempFilePath.split("/")[12];
        if(req.user.user_type == 'hospital2'){
            hid = 2;
        }
        else if(req.user.user_type == 'hospital1'){
            hid = 1;
        }
         mmedicine = {m_type: req.body.m_type, hid: hid,// m_mid: medid,
            m_name: req.body.m_name, m_num: req.body.m_num, m_price: req.body.m_price,
            m_status: req.body.m_status, m_picture: tmpfile, m_gongneng: req.body.m_gongneng,
            m_guige: req.body.m_guige, m_yongfa: req.body.m_yongfa, m_buliangfanying: req.body.m_buliangfanying,
            m_youxiaoqi: req.body.m_youxiaoqi, m_producerName: req.body.m_producerName, m_producerAddress: req.body.m_producerAddress,
            m_wenhao: req.body.m_wenhao, m_chengfen: req.body.m_chengfen};
            res.redirect('/medicine');
    })
	// =====================================
	// LOGOUT ==============================
	// =====================================
	app.get('/logout', function(req, res) {
		req.logout();
		res.redirect('/');
	});

	// =====================================
	// Forms for User Staff ================
	// =====================================
	//护士挂号页面（登记。先登记才能体检和门诊）（医疗端独立功能）
	app.get('/guahao',function (req,res) {
        connection.query('select * from patient left join bingren on patient.pid=bingren.id where bingren.id is NULL', function (err, rows) {
            //console.log(rows);
            res.render('guahao',{test:'patientlist' ,patient: rows} );
        })
    })

	//护士体检病人页面（查看已登记病人列表）（医疗端独立功能）
	app.get('/newPatient', function(req, res){
        connection.query('select * from bingren where tijian = 1', function (err, rows) {
            //console.log(rows);
            res.render('admitpatient',{test:'patientlist' ,patient: rows} );
        })
        //res.render('patient_entry_form.ejs');
    })
	//搜索病人名称（医疗端独立功能）
    app.post('/newPatient', function(req, res){
    	var username = req.body.patientname;
        connection.query('select * from bingren where bingren.tijian = 1  and username like \'%'+ username +'%\'', function (err, rows) {
            //console.log(rows);
            res.render('admitpatient',{test:'patientlist' ,patient: rows} );
        })
        //connection.query('select * from bingren where tijian = 1', function (err, rows) {
        //    //console.log(rows);
        //    res.render('admitpatient',{test:'patientlist' ,patient: rows} );
        //})

        //var user = {username: req.body.username,password: req.body.password, user_type: "Patient"};
        //connection.query("INSERT INTO pre_user SET ?", user, function (err,res) {
        //	if (err) throw err;
        //	connection.query("SELECT * FROM user WHERE username = ? ",user.username, function(err, row){
        //		if(err) throw err;
        //		pid = row[0].id;
        //	});
        //});
        //res.render('system_entry_form_patient_table.ejs');
    })

	//完成体检后跳转（将体检完成flag存入/tijianwancheng路由中）（医疗端独立功能）
    app.post('/tijianwancheng', function(req, res){
        var tijian = req.body.tijian;
        connection.query("update bingren set tijian='" + tijian + "' where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                res.redirect('/tijianwancheng');
            }
        });
    })
	//显示体检完成页面（医疗端独立功能）
	app.get('/tijianwancheng', function(req, res){
        connection.query("select * from bingren where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                res.render("tijianwancheng", {datas: rows});       //直接跳转
            }
        });
    })
	//完成诊断后跳转（将体检完成flag存入/chongxintijian路由中）（医疗端独立功能）
    app.post('/chongxintijian', function(req, res){
        //var tijian = req.body.tijian;
        //var diagnosis = req.body.diagnosis;
        //connection.query("update bingren set tijian='" + tijian + "',diagnosis='"+ diagnosis +"' where id=" + pid, function (err, rows) {
        //    if (err) {
        //        res.end('修改失败：' + err);
        //    } else {
        //        res.redirect('/chongxintijian');
        //    }
        //});
        var symptomId = req.body.symptomId;
        connection.query("update relationship set symptomId='" + symptomId + "' where rid=" + rid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                res.redirect('/chongxintijian');
            }
        });
    })
	//诊断完成页面导出word文档（导出文档的路由）
    app.get('/chongxintijian', function(req, res){
        //connection.query("select * from bingren where id=" + pid, function (err, rows) {
        //    if (err) {
        //        res.end('修改页面跳转失败：' + err);
        //    } else {
        //        res.render("chongxintijian", {datas: rows});       //直接跳转
        //    }
        //});
        var bdate,description,officeid,symptomId,office,symptom,pname,pid,icd,hid,hname,allergic,age,sex,telephone;
        connection.query("select * from relationship where rid=" + rid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                bdate = rows[0].bdate;
                description = rows[0].description;
				pid = rows[0].pid;
				officeId = rows[0].officeId;
				hid = rows[0].hid;
				allergic = rows[0].allergic;
				
				 connection.query("select * from patient where pid=" + pid, function (err, row_4) {
				
					pname = row_4[0].pname;
					icd = row_4[0].icd;
					sex_num = row_4[0].sex;
					if(sex_num == 0)
					{
						sex ='男';
					}else{
					
						sex = '女';
					}
					telephone = row_4[0].telephone;
				
				
				 connection.query("select * from hospital where hid=" + hid, function (err, row_5) {
				
					hname = row_5[0].hname;
				
				
		
				
				
                connection.query("select * from office where officeId=" + rows[0].officeId, function (err, row) {
                    office = row[0].officeName;
					
                    connection.query("select * from symptom where symptomId=" + rows[0].symptomId, function (err, roww) {
                        symptom = roww[0].symptomName;

                   
						var textarr="病人名:"+pname+ "\n 性别："+sex+"\n联系方式: "+telephone+"\n社保账号:"+icd+"\n就诊医院:"+hname+"\n是否对药物过敏："+allergic+"\n日期:"+bdate+"\n描述: "+description+"\n科室: "+office+"\n诊断: "+symptom;
						fs.writeFile('/home/songjian/go/src/github.com/hyperledger/MedRec/App/server/hospital-management-system-master/file/'+rows[0].rid+'.txt',textarr,function(err)
						{
							if(err)
							{
								console.log('ERR: '+err);
							}
							
						})
                        //var textarr=['日期：','描述：','科室：','诊断：'];
                       /* for(var j=0;j<textarr.length;j++){
                            var pcontent=textarr[j];
                            var pObj = docx.createP();
                            pObj.addText (pcontent, { font_face: 'Arial', font_size: 14 });
                        }*/
                        //var pcontent='Date :';
                        //var pObj = docx.createP();
                        //pObj.addText (pcontent, { font_face: 'Arial', font_size: 14 });
                        //var pObj = docx.createP();
                        //pObj.addText (bdate, { font_face: 'Arial', font_size: 14 });
                        //var pcontent='Description:';
                        //var pObj = docx.createP();
                        //pObj.addText (pcontent, { font_face: 'Arial', font_size: 14 });
                        //var pObj = docx.createP();
                        //pObj.addText (description, { font_face: 'Arial', font_size: 14 });
                        //var pcontent='Office     :';
                        //var pObj = docx.createP();
                        //pObj.addText (pcontent, { font_face: 'Arial', font_size: 14 });
                        //var pObj = docx.createP();
                        //pObj.addText (office, { font_face: 'Arial', font_size: 14 });
                        //var pcontent='Symptom    :';
                        //var pObj = docx.createP();
                        //pObj.addText (pcontent, { font_face: 'Arial', font_size: 14 });
                        //var pObj = docx.createP();
                        //pObj.addText (symptom, { font_face: 'Arial', font_size: 14 });
                        //var out = fs.createWriteStream ('C:/Users/Administrator/Desktop/testttttt/test'+ rows[0].rid +'.docx');
						

                        /*var out = fs.createWriteStream (
				'/home/songjian/go/src/github.com/hyperledger/MedRec/App/server/hospital-management-system-master/file/'+rows[0].rid+'.docx');//导出的word路径
                        //out.on ('error', function (err) {
                        //    res.send(err);
                        //});
                        docx.generate (out);*/
                        //res.redirect("chongxintijian", {datas: rows});
                        res.redirect('/diagnose?id='+rid);
                    })
                })
				  })
                //直接跳转
				 })
            }
        });
    })
    //完成挂号后跳转(提交挂号信息）（医疗端独立功能）
    app.post('/guahaowancheng', function(req, res){
        console.log(bingrenid)
        var patientid;
        var name = req.body.name;
        var age = req.body.age;
        var symptoms = req.body.symptoms;
        connection.query("select * from patient where pid="+bingrenid,function (err,row) {
            //result.forEach(function (row) {
            patientid = row[0].pid;
            console.log(patientid);
            connection.query("select * from bingren where id=?", row[0].pid, function (err, bingrenrows) {
                if (bingrenrows[0] == null) {
                    connection.query("insert into bingren (id) values(?)", row[0].pid, function (err, rows) {
                        if (err) {
                            res.end('修改失败：' + err);
                        } else {
                            connection.query("update bingren set username='" + name + "',symptoms='"+ symptoms +"',password='"+ age +"' where id=" + bingrenid, function (err, rows) {
                                if (err) {
                                    res.end('修改失败：' + err);
                                } else {
                                    //res.redirect('/guahaowancheng');
                                }
                            });
                            //console.log(patientid);
                        }
                    })
                }
            })
        })
        //var diagnosis = req.body.diagnosis;
        res.redirect('/guahaowancheng');
    })
    //显示完成挂号页面（医疗端独立功能）
    app.get('/guahaowancheng', function(req, res){
        connection.query("select * from bingren where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                res.render("guahaowancheng", {datas: rows});       //直接跳转
            }
        });
    })
	//将护士体检页面（未体检病人列表）输入的id存入/tijian页面中（医疗端独立功能）
    app.post('/tijian', function(req, res){
		bingrenid= req.body.id;
        connection.query("select * from bingren where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                res.render("tijian", {datas: rows});       //直接跳转
            }
        });
    })
	//显示体检页面（可通过选择病人列表病人对应行跳转）（医疗端独立功能）
    app.get('/tijian', function (req, res) {
        ////console.log(id);
		if(req.query.id) {
            bingrenid = req.query.id;
        }
        connection.query("select * from bingren where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                res.render("tijian", {datas: rows});       //直接跳转
            }
        });
    });
	//挂号页面（通过输入进行跳转）（医疗端独立功能）
    app.post('/admit', function(req, res){
        bingrenid= req.body.id;
        connection.query("select * from bingren where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                res.render("amit", {datas: rows});       //直接跳转
            }
        });
    })
    //显示体检页面（可通过选择病人列表病人对应行跳转）（医疗端独立功能）
    app.get('/admit', function (req, res) {
        ////console.log(id);
        if(req.query.id) {
            bingrenid = req.query.id;
        }
        //});
        connection.query("select * from patient where pid=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                res.render("amit", {datas: rows});       //直接跳转
            }
        });
    });

	//app.get('/:id',function(req,res){
	//	bingrenid = req.params.id;
	//	res.redirect('/tijian')
    //})
	//医生诊断页面（可通过选择病人列表病人对应行跳转）诊断诊断诊断 通过点击病人从路由参数获取relationship表的rid字段 显示对应行信息
 app.get('/diagnose', function(req, res){
        if(req.query.id) {
            rid = req.query.id;
        }
        //connection.query("select * from relationship where rid=" + rid, function (err, rows) {
        //    if (err) {
        //        res.end('修改页面跳转失败：' + err);
        //    } else {
        //        connection.query("select * from symptom where officeId=" + rows[0].officeId, function (err, rows1) {
        //            if (err) {
        //                res.end('修改页面跳转失败：' + err);
        //            } else {
        //                res.render("diagnose", {datas: rows , datas1:rows1});       //直接跳转
        //            }
        //        });
        //    }
        //});
        connection.query("select * from relationship where rid=" + rid, function (err, rows) {
            if (err) {
                res.end('修改页面跳转失败1：' + err);
            } else {
                connection.query("select * from symptom where officeId=" + rows[0].officeId, function (err, rows1) {
                    if (err) {
                        res.end('修改页面跳转失败2：' + err);
                    } else {
                        if(rows[0].symptomId) {
                            connection.query("select * from symptom where symptomId=" + rows[0].symptomId, function (err, row) {
                                if (err) {
                                    res.end('修改页面跳转失败3：' + err);
                                } else {
                                    connection.query("select * from medicine where m_type= ?", row[0].symptomName, function (err, rows2) {
                                        if (err) {
                                            res.end('修改页面跳转失败4：' + err);
                                        } else {
                                            if(rows[0].mid) {
                                                connection.query("select * from medicine where mid= ?", rows[0].mid, function (err, med) {
                                                    if (err) {
                                                        res.end('修改页面跳转失败4：' + err);
                                                    } else {
                                                        res.render("diagnose", {
                                                            datas: rows,
                                                            datas1: rows1,
                                                            datas2: rows2,
                                                            data: row[0].symptomName,
                                                            data4: med[0].m_name
                                                        });       //直接跳转
                                                    }
                                                });
                                            }else res.render("diagnose", {
                                                datas: rows,
                                                datas1: rows1,
                                                datas2: rows2,
                                                data: row[0].symptomName,
                                                data4: ''
                                            });
                                            //res.render("diagnose", {datas: rows , datas1:rows1, datas2 : rows2, data:row});       //直接跳转
                                        }
                                    });
                                }
                            });
                        }
                        else res.render("diagnose", {
                            datas: rows,
                            datas1: rows1,
                            datas2: rows1,
                            data: '',
                            data4: ''
                        });       //直接跳转
                    }
                });
                //res.render("diagnose", {datas: rows});       //直接跳转
            }
        });
    })
	//诊断诊断诊断 修改relationship表，增加symptomid字段和mid字段
    app.post('/diagnose', function(req, res){
        var symptomId = req.body.symptomId;
        var mid = req.body.mid;
        connection.query("update relationship set symptomId='" + symptomId + "' where rid=" + rid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                connection.query("update relationship set mid='" + mid + "' where rid=" + rid, function (err, rows) {
                    res.redirect('/diagnose?id='+rid);
                })
            }
        });
    })
    //检验项目（医疗端独立功能）
    app.get('/laboratories', function(req, res){
        if(req.query.id) {
            pid = req.query.id;
        }
        connection.query("select * from relationship where rid=" + pid, function (err, rowss) {
            pid = rowss[0].pid;

        connection.query("select * from bingren where id=" + pid, function (err, rows) {
            if(rows[0])
             {
                res.render("laboratories", {datas: rows});       //直接跳转
            }
            else {
                connection.query('select * from relationship where hid = ?',hid, function (err, row) {
                    //console.log(rows);
                    res.render('id_prescription',{test:'patientlist' ,patient: row, datastring:'请联系护士进行检查检验'} );
                })
            }
        });
        });
    })
    //（医疗端独立功能）
    app.post('/laboratories', function(req, res){
        var tijian = req.body.tijian;
        var diagnosis = req.body.diagnosis;
        var zhuyuan = req.body.zhuyuan;
        connection.query("update bingren set tijian='" + tijian + "',diagnosis='"+ diagnosis +"',zhuyuan = '"+ zhuyuan +"' where id=" + pid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                res.redirect('/patient');
            }
        });
    })


   
   
   
   
	
   
	


	// POST REQUEST  for Patient Entry======


    //（医疗端独立功能）
	app.get('/tijian1', function(req, res){
        connection.query('select * from bingren where id=' + bingrenid, function (err, rows) {
            //console.log(rows);
            res.render('tijian1',{test:'身高体重检测' ,datas: rows} );
        })
    })
    app.get('/tijian2', function(req, res){
        connection.query('select * from bingren where id=' + bingrenid, function (err, rows) {
            //console.log(rows);
            res.render('tijian2',{test:'血压与心脏' ,datas: rows} );
        })
    })
    app.get('/tijian3', function(req, res){
        connection.query('select * from bingren where id=' + bingrenid, function (err, rows) {
            //console.log(rows);
            res.render('tijian3',{test:'血液常规检测' ,datas: rows} );
        })
    })
    app.get('/tijian4', function(req, res){
        connection.query('select * from bingren where id=' + bingrenid, function (err, rows) {
            //console.log(rows);
            res.render('tijian4',{test:'内科与外科检测' ,datas: rows} );
        })
    })
    app.post('/tijian1', function(req, res){
        var shengao = req.body.shengao;
        var tizhong = req.body.tizhong;
        connection.query("update bingren set shengao='" + shengao + "',tizhong='" + tizhong + "' where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                res.redirect('/tijian');
            }
        });
    })
    app.post('/tijian2', function(req, res){
        var shousuoya = req.body.shousuoya;
        var shuzhangya = req.body.shuzhangya;
        var xintiao = req.body.xintiao;
        connection.query("update bingren set shousuoya='" + shousuoya + "',shuzhangya='" + shuzhangya + "',xintiao='"+ xintiao +"' where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                res.redirect('/tijian');
            }
        });
    })
    app.post('/tijian3', function(req, res){
        var xueye = req.body.xueye;
        connection.query("update bingren set xuejian='" + xueye + "' where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                res.redirect('/tijian');
            }
        });
    })
    app.post('/tijian4', function(req, res){
        var neike = req.body.neike;
        var waike = req.body.waike;
        connection.query("update bingren set neike='" + neike + "',waike='" + waike + "' where id=" + bingrenid, function (err, rows) {
            if (err) {
                res.end('修改失败：' + err);
            } else {
                res.redirect('/tijian');
            }
        });
    })
    //没用
	app.post('/newPatientProfile', function(req, res){
		var ppatient = {pid, fname: req.body.fname, mname: req.body.mname, lname: req.body.lname, 
			bdate: req.body.bdate, adate: req.body.adate, mblnoOne: req.body.mblnoOne, 
			mblnoTwo: req.body.mblnoTwo, gender: req.body.gender, streetno: req.body.streetno, 
			streetname: req.body.streetname, area: req.body.area, thana: req.body.thana, 
			district: req.body.district, pstreetno: req.body.pstreetno, pstreetname: req.body.pstreetname, 
			parea: req.body.parea, pthana: req.body.pthana, pdistrict: req.body.pdistrict, job: req.body.job, 
			deposit: req.body.deposit, admitted_ward: req.body.ward};
		connection.query("INSERT INTO patient SET ?", ppatient, function (err,res){
			if (err) throw err;
		});
		res.redirect('/profile');
	})


	// Prescription Entry
    //没用
	app.post("/newPrescription",function(req,res){
  		g = req.body.id;
  		res.render("radio_prescription");
  	});
    //没用
    app.get('/remedy', function(req, res){
        connection.query('select * from bingren where id=' + pid, function (err, rows) {
            //console.log(rows);
            connection.query('INSERT INTO bill (id,) VALUES (?,0,0)',pid, function (err, rows) {
                //console.log(rows);
            })
            res.render("radio_prescription",{datas: rows});
        })
    })
    //INSERT INTO bill (id) VALUES (1);
    //没用
    app.post('/newRadioReport', function(req, res){
		
		var sum = 0;

		var a = Number(req.body.a);
		var b = Number(req.body.b);
		var c = Number(req.body.c);
		g = pid;

		if(!isNaN(a))
			sum = sum + a;

		if(!isNaN(b))
			sum = sum + b;

		if(!isNaN(c))
			sum = sum + c;

		connection.query("UPDATE bill SET total_payable = total_payable + ? WHERE id = ?", [sum,g]);


		res.render('image_prescription');
	})
    //没用
	app.post('/newImageReport', function(req, res){
		
		var sum = 0;

		var a = Number(req.body.a);
		var b = Number(req.body.b);
		var c = Number(req.body.c);

		if(!isNaN(a))
			sum = sum + a;

		if(!isNaN(b))
			sum = sum + b;

		if(!isNaN(c))
			sum = sum + c;

		connection.query("UPDATE bill SET total_payable = total_payable + ? WHERE id = ?", [sum,g]);

		res.render('path_prescription');
	})
    //没用
	app.post('/newPathReport', function(req, res){
		
		var sum = 0;

		var a = Number(req.body.a);
		var b = Number(req.body.b);
		var c = Number(req.body.c);

		if(!isNaN(a))
			sum = sum + a;

		if(!isNaN(b))
			sum = sum + b;

		if(!isNaN(c))
			sum = sum + c;

		connection.query("UPDATE bill SET total_payable = total_payable + ? WHERE id = ?", [sum,g]);

		//res.render('medicine_prescription.ejs');
        res.redirect('/profile');
	})
    //没用
	app.post('/newPrescribedMedicine', function(req, res){
		
		var sum;
		console.log(typeof(req.body.name));
		connection.query("SELECT * FROM medicine WHERE name = ? ",req.body.name1, function(err, row){

  			if(err) throw err;
  			quantity = Number(row[0].quantity);
  			u_price = Number(row[0].u_price);
  			m_id = Number(row[0].mid);
  			var x = parseInt(req.body.quantity1);


  		if(!((quantity - x) < 0)){
  			connection.query('UPDATE medicine SET quantity = quantity - ? WHERE mid = ?',[x,m_id]);
  			sum = x*u_price;
  			connection.query('UPDATE bill SET total_payable = total_payable + ? WHERE id = ?',[sum,g]);
  		}
  		});

  		connection.query("SELECT * FROM medicine WHERE name = ? ",req.body.name2, function(err, row){

  			if(err) throw err;
  			quantity = Number(row[0].quantity);
  			u_price = Number(row[0].u_price);
  			m_id = Number(row[0].mid);
  			var x = parseInt(req.body.quantity2);

  		if(!((quantity - x) < 0)){
  			connection.query('UPDATE medicine SET quantity = quantity - ? WHERE mid = ?',[x,m_id]);
  			sum = x*u_price;
  			connection.query('UPDATE bill SET total_payable = total_payable + ? WHERE id = ?',[sum,g]);
  		}
  		});

  		connection.query("SELECT * FROM medicine WHERE name = ? ",req.body.name3, function(err, row){

  			if(err) throw err;
  			quantity = Number(row[0].quantity);
  			u_price = Number(row[0].u_price);
  			m_id = Number(row[0].mid);
  			var x = parseInt(req.body.quantity3);
  		if(!((quantity - x) < 0)){
  			connection.query('UPDATE medicine SET quantity = quantity - ? WHERE mid = ?',[x,m_id]);
  			sum = x*u_price;
  			connection.query('UPDATE bill SET total_payable = total_payable + ? WHERE id = ?',[sum,g]);
  		}
  		});

		res.redirect('/profile');

	})

	// POST REQUEST  for Medicine Entry=========
    //没用
	app.post('/newMedicine', function(req, res){
		
		
		var mmedicine = {name: req.body.name, type: req.body.type, u_price: req.body.u_price, 
			quantity: req.body.quantity, mdate: req.body.mdate, edate: req.body.edate};	
		
		connection.query("INSERT INTO medicine SET ?", mmedicine);

		res.redirect('/profile');

	});	



	// Patient Due bill
    //没用
	app.get('/dueBill', function(req,res){
  		
  		connection.query('select due from bill_due where id = ?',bill_id,function(err,rows){
			if(err){
					console.log(err);
					return;
			}
			res.render("billDetails",{dueBill: rows[0].due});
		});	
	});
    //没用
	 app.post('/update_payment', function(req, res) {

  		var paid = parseInt(req.body.paid);
    	connection.query("UPDATE bill SET paid = paid + ? WHERE id = ?",[paid,req.body.id] );
    	res.render("StaffIndex");
  	
  	});
    //没用
	app.post('/delete_user', function(req, res) {
  		var id = parseInt(req.body.id);
    	connection.query("DELETE FROM user WHERE id = ?",id);
    	res.render("StaffIndex");
  	});



	//app.get("/:x",function(req,res){
	//	console.log("Someone has made a get req at "+String(req.params.x));
	//	res.render(req.params.x);
	//});
    //-----------------------注册新用户-------------------------------------------
    //页面
    app.get('/exportWord', function(req, res){
                res.render("exportWord");       //直接跳转
    })
    //将注册信息存入newuser和hospitaluser中
    app.post('/adduser', async function(req, res){

        var hosptial = req.body.hid;
		var password = req.body.password;
		var haddress = req.body.haddress;
		var htelephone = req.body.htelephone;
		var hdescription = req.body.hdescription;
        var hhname;
        var uuserid;
		var hid;
        if (hosptial ==1){
			hid = 1;
            hhname = '淮安市第一人民医院';
            uuserid = 10002;
            newuser = {username: hhname,password: password, user_type: "hospital1",id:10002};

            try {
                let result = await identity.registerUser("hospital1");
                if (result === true) {  //判断是否存在已注册的用户
                    //生成公私钥对
                    let res = await crypto_rsa.generator("hospital1");
                    console.log('生成公私钥');
                    console.log(res);
                    if (res === true) {   //如果生成了公私钥对   这里因为生成的公私钥需要时间，所以设置了一个定时器，不然执行太快下面读取不到
                        setTimeout(async () => {
                            await crypto_rsa.getPubkey("hospital1").then(pubkey => {
                                console.log('获取公钥');
                                console.log(pubkey.toString());
                                setTimeout(async () => {
                                    console.log(`hospital1的RSA公钥是${pubkey}`);
                                    await tx_op.invokeTx('hospital1','information', false, 'addInfo', pubkey)
                                    //从本地提取公钥(字符串)，准备上链（此处只需要对公钥上链，上传者的身份，已经在链码中处理）
                                    
                                }, 2000)
                            })
                           
                        }, 2000)
                        
                    }
                    //这里为了用户体验，注册完用户之后直接跳转，无需等上面提交交易之后跳转
                    console.log('success');
                } else if (result === false) {
                    console.log('user has been exist');
                }
        
            } catch (error) {
                console.log(error);
            }


        }
        if (hosptial ==2){
            hhname = '淮安市第二人民医院';
            uuserid = 10003;
			hid = 2;
            newuser = {username: hhname,password: password, user_type: "hospital2",id:10003};

            try {
                let result = await identity.registerUser("hospital2");
                if (result === true) {  //判断是否存在已注册的用户
                    //生成公私钥对
                    let res = await crypto_rsa.generator("hospital2");
                    console.log('生成公私钥');
                    console.log(res);
                    if (res === true) {   //如果生成了公私钥对   这里因为生成的公私钥需要时间，所以设置了一个定时器，不然执行太快下面读取不到
                        setTimeout(async () => {
                            await crypto_rsa.getPubkey("hospital2").then(pubkey => {
                                console.log('获取公钥');
                                console.log(pubkey.toString());
                                setTimeout(async () => {
                                    console.log(`hospital2的RSA公钥是${pubkey}`);
                                    await tx_op.invokeTx("hospital2",'information', false, 'addInfo', pubkey)
                                    //从本地提取公钥(字符串)，准备上链（此处只需要对公钥上链，上传者的身份，已经在链码中处理）
                                    
                                }, 2000)
                            })
                           
                        }, 2000)
                        
                    }
                    //这里为了用户体验，注册完用户之后直接跳转，无需等上面提交交易之后跳转
                   console.log('success');
                } else if (result === false) {
                    console.log('exist');
                }
        
            } catch (error) {
                console.log(error);
            }



        }
        hospitaluser = {hid:hid,hname:hhname,userid:uuserid,husername:req.body.username,hpassword:req.body.password,hlevel:"全国三甲",haddress:haddress,htelephone:htelephone,hdescription:hdescription};
        res.redirect('/');
    })
    //-----------------------注册新用户-------------------------------------------
	//app.use(function(err, req, res, next) {
    //    res.render("404");
    //});
    //没用
    app.post('/api/upload', function (req, res, next) {
        var fileName = req.file.filename;
        var destDir = req.body.dir == undefined ? "default" : req.body.dir;
        var sourceFile = req.file.path;
        var destPath = path.join(__dirname.replace("routes", ""), "uploads", destDir, fileName);
        var dest_Dir = path.join(__dirname.replace("routes", ""), "uploads", destDir);
        var fileurl = uploadFileDomin + destPath.substr(destPath.indexOf("uploads"));
        fileurl = fileurl.replace(/\\/g, "/");
        fs.exists(dest_Dir, function (exists) {
            if (exists) {
                fs.rename(sourceFile, destPath, function (err) {
                    res.status(200).json({
                        httpCode: 200,
                        message: '上传成功',
                        data: {
                            "fileurl": fileurl
                        },
                    });
                });
            }
            else {
                fs.mkdir(dest_Dir, 0777, function (err) {
                    if (err) {
                        res.status(500).json({
                            httpCode: 500,
                            message: err,
                            data: [],
                        });
                    } else {
                        fs.rename(sourceFile, destPath, function (err) {
                            res.status(200).json({
                                httpCode: 200,
                                message: '上传成功',
                                data: {
                                    "fileurl": fileurl
                                },
                            });
                        });
                    }
                })
            }
        });

    });
    //图片测试
    app.get("/test",function(req,res){
        res.render('test');
    });
    app.post('/test',upload.single('files'),function (req,res,next) {
        res.render('<img src="./"+>')
    })

    //app.get("*",function(req,res){
    //    console.log("Someone has made a get req at 404");
    //    res.render("404");
    //});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
    //------------------入出院登记处-------------------------------------------------------------------------
   app.get('/inp_adt', function(req, res){
        if(inp != null){
			
			
			
			console.log('xxxxxxxxxxxxxxx插了');
            connection.query("insert into pats_in_hospital SET ?", inp,function (err, rows){
            })
            connection.query("update bingren SET zhuyuan=3 where id=? ", inp.id,function (err, rows){
            })
            inp = null;
        }
        connection.query("select * from office", function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select * from bingren where zhuyuan = 1', function (err, row) {
                    res.render('inp_adt.ejs',{test:'patientlist',patient:row , dept:rows1 } );
                })
            }
        });
    })
    app.get('/inp_adt1', function(req, res){
        if(req.query.id) {
            pid = req.query.id;
        }
        connection.query("select * from office", function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select * from bingren where zhuyuan = 1', function (err, row) {
                    res.render('inp_adt1.ejs',{test:'patientlist',datas:row , datas1:rows1 } );
                })
            }
        });
    })
    //搜索病人名称
    app.post('/inp_adt1', function(req, res){
        inp = {id: req.body.id,
            name: req.body.name,
            diagnosis: req.body.diagnosis,
            dept_code: req.body.dept};
        res.redirect('/inp_adt');
    })
    app.post('/inp_adt2', function(req, res){
        connection.query('select * from bingren where ', function (err, rows) {
            //console.log(rows);
            res.render('admitpatient',{test:'patientlist' ,patient: rows} );
        })
    })
    app.get('/chuyuan', function(req, res){
        pid = global.pid;
        connection.query("select * from pats_in_hospital where id = ?",pid, function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select * from inporders where patient_id = ?',pid, function (err, row) {
                    connection.query('select sum(cost) sum from inporders where patient_id = ?',pid, function (err, row2) {
                        res.render('chuyuan.ejs',{test:'orderlist',order:row , patient:rows1,totalcost:row2[0].sum } );
                    })
                })
            }
        });
    })
    app.post('/chuyuan', function(req, res){
        pid = global.pid;
        connection.query("delete from pats_in_hospital where id = ?",pid, function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('delete from inporders where patient_id = ?',pid, function (err, row) {
                    res.redirect('/inp_nur')
                })
            }
        });
    })
    //--------------------------------------------------------------------------------------------------------

    //------------------住院医生站-------------------------------------------------------------------------
    //病人列表
    app.get('/inp_doctor', function(req, res){
        connection.query("select * from office", function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select * from pats_in_hospital', function (err, row) {
                    res.render('inp_doctor.ejs',{test:'patientlist',patient:row , dept:rows1 } );
                })
            }
        });
    })
    //医嘱列表
    app.get('/orders', function(req, res){
            global.pid = req.query.id;
            pid = global.pid;
        if(addorders != null){
            connection.query("insert into inporders SET ? ", addorders,function (err, rows){
            })
            addorders = null;
        }
        connection.query("select * from pats_in_hospital where id = ?",pid, function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select * from inporders where patient_id = ?',pid, function (err, row) {
                    res.render('orders.ejs',{test:'orderlist',order:row , patient:rows1,pid:pid } );
                })
            }
        });
    })
    //医嘱新增
    app.get('/addorders', function(req, res){
        connection.query("select * from pats_in_hospital where id = ?",pid, function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                    res.render('addorders.ejs',{test:'orderlist', patient:rows1 } );
            }
        });
    })
    app.post('/addorders', function(req, res){
        addorders = {patient_id: pid, item_name: req.body.item_name, pinci: req.body.pinci,
            chuyuantongzhi:req.body.chuyuan, cost: req.body.costs, description: req.body.description, status:'新开'}
        res.redirect('/orders?id='+ pid );
    })
    app.get('/orderdetail', function(req, res){
        if(req.query.id) {
            orderid = req.query.id;
        }
        pid = global.pid
        connection.query("select * from pats_in_hospital where id = ?",pid, function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query("select * from inporders where id = ?",orderid, function (err, rows) {

                    res.render('orderdetail',{test:'patientlist' ,datas: rows, patient:rows1} );
                })
            }
        });

    })
    app.post('/orderdetail', function(req, res){
        pid = global.pid;
        addorders = {item_name: req.body.item_name, pinci: req.body.pinci,
             cost: req.body.costs, description: req.body.description, status:'新开'}
        connection.query("update inporders SET ? where id = "+ orderid, addorders);
        addorders = null;
        res.redirect('/orders?id='+ pid);
    })
    //--------------------------------------------------------------------------------------------------------

    //------------------住院护士站-------------------------------------------------------------------------
    app.get('/inp_nur', function(req, res){
        connection.query("select * from office", function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select a.*,(select count(*) count from inporders b where b.patient_id = a.id and b.`status`=\'新开\') count from pats_in_hospital a', function (err, row) {
                    res.render('inp_nur.ejs',{test:'patientlist',patient:row , dept:rows1 } );
                })
            }
        });
        //res.render('patient_entry_form.ejs');
    })
    app.get('/nurorders', function(req, res){
        global.pid = req.query.id;
        pid = global.pid;
        if(addorders != null){
            connection.query("insert into inporders SET ? ", addorders,function (err, rows){
            })
            addorders = null;
        }
        connection.query("select * from pats_in_hospital where id = ?",pid, function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select * from inporders where patient_id = ?',pid, function (err, row) {
                    res.render('nurorders.ejs',{test:'orderlist',order:row , patient:rows1 } );
                })
            }
        });
    })
    app.get('/nurorderdetail', function(req, res){
        if(req.query.id) {
            orderid = req.query.id;
        }
        global.orderid = orderid;
        pid = global.pid;
        connection.query("select * from pats_in_hospital where id = ?",pid, function (err, rows1) {
            if (err) {
                res.end('修改页面跳转失败：' + err);
            } else {
                connection.query('select * from inporders where id = ?',orderid, function (err, rows) {
                    console.log(rows[0].chuyuantongzhi)
                    res.render('nurorderdetail',{test:'patientlist' ,datas: rows, patient:rows1} );
                })
            }
        });

    })
    app.post('/nurorderdetail', function(req, res){
        orderid=global.orderid;
        pid = global.pid;
        connection.query("update inporders SET status ='执行中'  where id = "+ orderid);
        addorders = null;
        res.redirect('/nurorders?id='+ pid);
    })
    //--------------------------------------------------------------------------------------------------------




    //-----------------ui界面----------------------------------------------------------------------------------
    app.get('/hospitalA', function(req, res){
        res.render('hospitalA.ejs');
    })
	
	
	
	/*
	上传病历
	
	*/	
    app.post('/add_record',async function(req, res){
        console.log(`开始上传雷神山医院A的病人的病历`);
        //var req = req.request.body;
        var patient = req.body.patient;
        var idnum = req.body.idnum;
        var hospital ;
		 if(req.user.user_type == 'hospital2'){
           hospital = 'hospital2'
        }
        else if(req.user.user_type == 'hospital1'){
            hospital = 'hospital1'
        }

        console.log('开始获取前端文件对象')
		  if (!req.files || Object.keys(req.files).length === 0) {
			return res.status(400).send('No files were uploaded.');
		}

  // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
	
		console.log(req.files.bili);
        let fileobj =  req.files.bili;
		console.log(fileobj);
        var filestr = JSON.stringify(fileobj);
        console.log('文件信息是'+filestr)
        var filepath = fileobj.tempFilePath;
        //let doctor =  ctx.get('userInfo');
        //通过文件路径，上传至ipfs
		
		
		
		//返回 ipfs哈希
        var ipfs_record = await ipfs.addfile(filepath);
		
		
		
		
        //键名为医院-医生-患者-身份证件号码/医保卡号
        console.log(`医院是${hospital},上传的文件的ipfs地址是${ipfs_record}`);
		
        //上传的key的格式
        var key = `${hospital}-${patient}-${idnum}`
        //从公共链上获取病人的公钥
        var pubkey = await tx_op.invokeTx(hospital, 'information', true, 'seleInfo', patient)
        console.log(`的病人${patient}的公钥是${pubkey}`);
        //通过病人的公钥对IPFS地址进行加密，得到密文（这个密文只有上面相应病人的公钥才能解开）
        var ipfs_hash = await crypto_rsa.encrypt(pubkey, ipfs_record)
        console.log(`ipfshash地址解密之后的密文是${ipfs_hash}`);
        //上传患者信息以及ipfs加密之后的hash值（上传到医院A与patient）
        await tx_op.invokeTx(hospital,'recordpa', false, 'addRecord', key, ipfs_hash).then(async () => {
            console.log('success');
        })
    })

};





// route middleware to make sure
function isLoggedIn(req, res, next) {

	// if user is authenticated in the session, carry on
	if (req.isAuthenticated())
		return next();

	// if they aren't redirect them to the home page
	res.redirect('/');
}

// con.query('select * from bill_due',function(err,rows){
// 	if(err){
// 		console.log(err);
// 		return;
// 	}
// 	rows.forEach(function(result){
// 		console.log(result.id,result.due);
// 	});
// });

// con.end(function(){
// 	console.log("Connection Closed...")
// });



