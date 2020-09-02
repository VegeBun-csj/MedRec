var db = require('./mysql');

var hospital = {

    hid: { type: 'serial', key: true } , //主键
    hname: String,
    husername: String,
    hpassword: String,
    hlevel: String,
    haddress: String,
    htelephone: String,
    hdescription: String
};

var Hospital = db.define('hospital',hospital);

module.exports=Hospital;