
var db = require('./mysql');

var patient = {

    pid: { type: 'serial', key: true } , //主键
    pname : String,
    pusername: String,
    ppassword: String,
    age: {type: 'integer'},
    sex: {type: 'integer'},
    telephone: {type: 'integer'},
    icd: {type: 'integer'},
    hid:{type: 'integer'}
};

var Patient = db.define('patient',patient);

module.exports = Patient;
