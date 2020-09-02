var db = require('./mysql');

var relationship = {
    allergic:String,
    rid: {type: 'serial',key:true},
    pid: {type: 'integer'},
    hid: {type: 'integer'},
    bdate: String,
    description: String,
    
    officeId: {type:'integer'},
    symptomId:{type: 'integer'},
    mid:{type: 'integer'}

};
var Relationship = db.define('relationship',relationship);

module.exports = Relationship;
