
var db = require('./mysql');

var patient_wallet = {

    yu_e:Number,
    
    p_wid: { type: 'serial', key: true } , //主键
    pid : {type:'integer'},
    password:String,
    p_wallet_name:String
   
};

var Patient_Wallet = db.define('patient_wallet',patient_wallet);

module.exports = Patient_Wallet;