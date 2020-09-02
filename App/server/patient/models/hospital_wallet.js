
var db = require('./mysql');

var hospital_wallet = {

    yu_e:Number,
    
    h_wid: { type: 'serial', key: true } , //主键
    hid : {type:'integer'},
    password:String
   
};

var Hospital_Wallet = db.define('hospital_wallet',hospital_wallet);

module.exports = Hospital_Wallet;