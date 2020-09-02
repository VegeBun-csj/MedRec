var db = require('./mysql');

var office = {

    officeId: {type: 'serial',key: true},
    officeType: {type: 'integer'},
    officeName:String,
    hid: {type: 'integer'}
};

var Office = db.define('office',office);
module.exports = Office;