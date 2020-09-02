'use strict'

const Koa = require('koa');
const path = require('path')
const bodyparser = require('koa-bodyparser');
const Router = require('koa-router')
const nunjucks = require('koa-nunjucks-2')
const crypto_rsa = require('./Identity/crypto_rsa')
const app = new Koa();
const router = new Router();
const identity = require('./Identity/identity_utils')
const tx_op = require('./tx_chain/tx_op')


 app.use(nunjucks({
    ext: 'html',
    path: path.join(__dirname, './views'),
    nunjucksConfig: {
        trimBlocks: true
    }

})) 




router.get('/', async (ctx) => {
    // ctx.body='MedRec'
    console.log('进入主页,同时注册管理员');
    await identity.enrollAdmin();
    //注意：async中一定要写await
    await ctx.render('index')
})



//=========================================>>>>>>>>>>>>>>>>>>>
//   注册用户：以下实现功能：在登陆的时候生成本地的rsa公私钥，并上链
//这里暂时统一注册所有用户(医院的医生，病人)的信息，实际项目中，需要分开设计
router.post('/register', async (ctx) => {
    console.log(ctx.request.body);
    let req = ctx.request.body;
    console.log(req.name);
    let username = req.name;
    console.log(username);
    try {
        let result = await identity.registerUser(username);
        if (result === true) {  //判断是否存在已注册的用户
            //生成公私钥对
            let res = await crypto_rsa.generator(username);
            console.log('生成公私钥');
            console.log(res);
            if (res === true) {   //如果生成了公私钥对   这里因为生成的公私钥需要时间，所以设置了一个定时器，不然执行太快下面读取不到
                setTimeout(async () => {
                    await crypto_rsa.getPubkey(username).then(pubkey => {
                        console.log('获取公钥');
                        console.log(pubkey.toString());
                        setTimeout(async () => {
                            console.log(`${username}的RSA公钥是${pubkey}`);
                            await tx_op.invokeTx(username, 'commonchannel', 'information', false, 'addInfo', pubkey)
                            //从本地提取公钥(字符串)，准备上链（此处只需要对公钥上链，上传者的身份，已经在链码中处理）
                            
                        }, 2000)
                    })
                   
                }, 2000)
                
            }
            await ctx.render('success');
        } else if (result === false) {
            await ctx.render('exist');
        }

    } catch (error) {
        console.log(error);
    }
})





/* 
    医院A（雷神山医院）接受患者来进行就诊时，上传患者的就诊信息
*/


//跳转至医院A的登陆界面
router.get('/hospitalA', async (ctx) => {
    console.log('就诊医院A登陆');
    await ctx.render('hospitalAlogin')
})



//进行医院医生用户的登陆验证，成功则进入医院A的患者信息上传页面 
router.post('/hospitalA_login', async (ctx) => {
    console.log('医院A登录校验');
    let req = ctx.request.body;
    console.log(req);
    let username = req.name;
    console.log(username);
    await identity.checkUser(username).then(async (exist) => {
        console.log(exist);
        if (exist) {
            ctx.cookies.set('userInfo', `${username}`, {
                maxAge: 60 * 1000 * 60
            })

            await ctx.render('hospitalA')
        }
        else {
            await ctx.render('error')
        }
    })
})


//上传信息---已解决
router.post('/add_record', async (ctx) => {
    console.log(`开始上传雷神山医院A的病人的病历`);
    let req = ctx.request.body;
    let patient = req.patient;
    let idnum = req.idnum;
    let hospital = req.hospital;
    let ipfs_record = req.record;
    let doctor = ctx.cookies.get('userInfo');
    //键名为医院-医生-患者-身份证件号码/医保卡号
    console.log(`医院是${hospital},操作的医生是${doctor},ipfs的地址是${ipfs_record}`);
    //上传的key的格式
    let key = `${hospital}-${doctor}-${patient}-${idnum}`
    //从公共链上获取病人的公钥
    let pubkey = await tx_op.invokeTx(doctor, 'commonchannel', 'information', true, 'seleInfo', patient)
    console.log(`获取的commonchannel上的病人${patient}的公钥是${pubkey}`);
    let ipfs_hash = await crypto_rsa.encrypt(pubkey, ipfs_record)
    console.log(`ipfshash地址解密之后的密文是${ipfs_hash}`);
    //上传患者信息以及ipfs加密之后的hash值（上传到医院A与patient的链channelpa上）
    await tx_op.invokeTx(doctor, 'channelpa', 'recordpa', false, 'addRecord', key, ipfs_hash).then(async () => {
        await ctx.render('success')
    })
})





/* 
患者操作界面

*/

//登录界面
router.get('/patientlogin', async (ctx) => {
    console.log('患者端开始登陆.....');
    await ctx.render('patientlogin')
})




router.post('/loginTo', async (ctx) => {
    console.log('开始验证患者登陆身份....');
    let req = ctx.request.body;
    console.log(req);
    let username = req.name;
    console.log(username);
    await identity.checkUser(username).then(async (exist) => {
        console.log(exist);
        if (exist) {
            ctx.cookies.set('userInfo', `${username}`, {
                maxAge: 60 * 1000 * 60
            })
            await ctx.render('patientmanage')
        }
        else {
            await ctx.render('error')
        }
    })
})




//从登陆界面跳转至患者管理界面：三个模块 
// 1.授权第三方医院查询病历，2.自己病历的信息查询 3.历史数据的查询


//进入授权界面，授权第三方医院查询自己的病历信息
//1.首先获取需要被授权的医院的医生的公钥===>>从链上获取
//2.利用获得的公钥，将前端的病历hash进行加密，得到miwen
//3.将miwen进行上链
router.get('/authority', async (ctx) => {
    console.log('开始授权第三方医院......');
    let resp = {};
    let req = ctx.query;
    let hospital = req.hospital;
    let doctor = req.doctor;
    let idnum = req.idnum;
    // tx_op.invokeTx('csj')
    let user = ctx.cookies.get('userInfo');
    console.log(`正在操作的用户是${user}`);
    //授权的时候的键名是患者-身份证号-医院-医生（跟医生上传病历是相反的）
    let key = `${user}-${idnum}-${hospital}-${doctor}`;
    //从链上获取doctor的公钥
    let pubkey = await tx_op.invokeTx(user, 'commonchannel', 'information', true, 'seleInfo', doctor)
    //通过doctor的公钥对IPFShash进行加密，得到密文
    console.log(`获取的医生的公钥是${pubkey}`);
    await crypto_rsa.encrypt(pubkey, req.record).then(async miwen => {
        //这里的密文是string类型的数据
        console.log(`加密后的密文时${miwen}`);
        await tx_op.invokeTx(user, 'channelpb', 'recordpb', false, 'addInfo', key, miwen).then(()=>{
            resp.success = true;
            resp.data = '授权成功';
        })
    });
    console.log(`resp的状态是${resp.data}`);
    ctx.body = JSON.stringify(resp);

})


/* 
患者查询页面，查询患者与医院A之间的病历信息获取的是最新的账本数据）
*/
router.get('/seleRecord', async (ctx) => {
    //接受前台的ajax请求，查询病历数据
    console.log('开始查询患者与医院的病例数据....');
    let req = ctx.query;
    let resp = {};
    let hospital = req.hospital
    let doctor = req.doctor;
    let idnum = req.idnum;
    let patientuser = ctx.cookies.get('userInfo')
    let key = `${hospital}-${doctor}-${patientuser}-${idnum}`
    await tx_op.invokeTx(patientuser, 'channelpa', 'recordpa', true, 'seleInfo', key).then(async (result) => {
        //result为查询的链上的ipfs加密之后的hash
        //拿病人本地的私钥，对这个hash进行解密，得到最终的ipfs上的hash地址
       
        let mingwen = await crypto_rsa.decrypt(patientuser, result.toString());
        result = mingwen;
        console.log(`明文是${result}`);
        console.log(Object.keys(result).length);
        if (Object.keys(result).length != 0) {
            resp.success = true;
            resp.data = result.toString();  //注意这里的result是buffer类型的数据，需要转为string
            console.log(`resp的响应是否成功是${resp.success},resp的数据为${resp.data}`);
        } else {
            resp.success = false;
            resp.data = '数据查询错误/没有此数据，请确保输入正确';
        }
    })
    console.log(`请求响应返回的json数据是${JSON.stringify(resp)}`);
    ctx.body = JSON.stringify(resp);

})



 /* 
    ==========================================================
    待解决：
    2.病人实现历史病历查询
    ======================================================
*/

router.post('/seleHistory',async(ctx)=>{
    console.log(`开始查询患者的历史病历`);
    let req = ctx.request.body;
    let resp = {};
    let hospital = req.hospital
    let doctor = req.doctor;
    let idnum = req.idnum;
    let patientuser = ctx.cookies.get('userInfo');
    let key = `${hospital}-${doctor}-${patientuser}-${idnum}`;
    let res =  await tx_op.invokeTx(patientuser,'channelpa','recordpa',true,'getHistoryForPatient',key);
    //注意res是buffer类型的数据
    console.log(`从链上查询的buffer类型的历史记录是${res}`);
    let result = res.toString();
    console.log(`转换为json对象之后为${res}`);
    if (Object.keys(result).length != 0) {
        let dataobj =  JSON.parse(result)   
        console.log(dataobj instanceof Array);
        console.log(`数据对象是${dataobj[0].transactionID}`);
        let a ='hahaha'
        await ctx.render('showhistory',{
            dataobj:dataobj,
            a:a
        }) 
    } else {
        resp.success = false;
        resp.data = '数据查询错误/没有此数据，请确保输入正确';
        await ctx.render('error')
    }
 
})













/* 
    第三方医院B（火神山医院，患者进行授权后，查询相关的患者信息）
*/

router.get('/thirdlogin',async (ctx) => {
    console.log('开始第三方医院火神山的登陆');
    await ctx.render('thirdpartlogin')
})



//第三方医院医生登录校验。查看本地是否有相关的账户信息
router.post('/thirdPart', async (ctx) => {
    console.log('第三方医院开始校验医生登陆信息');
    let req = ctx.request.body;
    console.log(req);
    let username = req.name;
    console.log(username);
    await identity.checkUser(username).then(async (exist) => {
        console.log(exist);
        if (exist) {
            ctx.cookies.set('userInfo', `${username}`, {
                maxAge: 60 * 1000 * 60
            })
            await ctx.render('thirdselect')
        }
        else {
            await ctx.render('error')
        }
    })
})




//第三方医院通过根据医院，医生来查询到对应的链上密文
//通过本地的自己的私钥，将密文进行解密，获得IPFSHASH，从而去IPFS进行获取数据
router.get('/thirdsele', async (ctx) => {
    console.log(`进入第三方医院登陆界面`);
    let req = ctx.query;
    let resp = {};
    let hospital = req.hospital;
    let patient = req.patient;
    let idnum = req.idnum;
    let user = ctx.cookies.get('userInfo')
    console.log(`cookie name is ${user}`);
    let key = `${patient}-${idnum}-${hospital}-${user}`;
    //医生通过这个授权的key获取链上的密文
    await tx_op.invokeTx(user, 'channelpb', 'recordpb', true, 'seleInfo', key).then(async miwen => {
        //从本地获取私钥，将miwen解密得到ipfs的hash值
        miwen = miwen.toString();
        let result =  await crypto_rsa.decrypt(user, miwen)
        if (Object.keys(result).length != 0) {
            resp.success = true;
            resp.data = result.toString();  //注意这里的result是buffer类型的数据，需要转为string
            console.log(`resp的响应是否成功是${resp.success},resp的数据为${resp.data}`);
        } else {
            resp.success = false;
            resp.data = '数据查询错误/没有此数据，请确保输入正确';
        }
    })
    console.log(`请求响应返回的json数据是${JSON.stringify(resp)}`);
    ctx.body = JSON.stringify(resp);
})



app
    .use(bodyparser())    
    .use(router.routes())
    .use(router.allowedMethods());
app.listen(3000, () => {
    console.log(`start  medrec application.......`);
    console.log(`请访问3000端口`);
})



//                      ............测试........................

// //创建一个admin用户（我这里设置的，默认是配置文件config.json中的adminPatient）
//  identity.enrollAdmin();
//创建一个user
// console.log(identity.registerUser('csj')); 
//检测是否存在user
/* identity.checkUser('11').then(result=>{
    console.log(result);
}) */

//调用交易
// let user = 'songjian';

//上传自己的公钥
//  tx_op.invokeTx(user,'commonchannel','information',false,'addInfo','2songjianjkdnakjdndkajdk')
//  tx_op.invokeTx(user,'commonchannel','information',true,'seleInfo',user)
//  tx_op.invokeTx(user,'channelpa','recordpa',false,'addRecord','user1','user1nksjakdsakdnaskjdnjk');
// tx_op.invokeTx(user,'channelpa','recordpa',true,'seleInfo','user1')
