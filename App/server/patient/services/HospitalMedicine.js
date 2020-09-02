
var Medicine = require('../models/medicine');
var Patient = require('../models/patient');
var db = require("../models/mysql");

var moment = require('moment');

//注册
exports.getMedicine = function(hid,callback){

   
        console.log(hid);
        hid1= parseInt(hid);

        Medicine.find({ hid:hid },function(err,medicines){
        
            //console.log(medicines.length);
            console.log(medicines[0].m_name);
            return callback(err,medicines);

        });
    
};








