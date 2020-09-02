
var Patient = require("../models/patient");
var Hospital = require("../models/hospital");
var db = require("../models/mysql");
var moment = require('moment');

//注册
exports.addPeople = function(username,password,work,callback){

    var newRecord = {};
    newRecord.username = username;
    newRecord.password = password;
   console.log(username+"8888888");
   console.log("hid:   "+work);


                Patient.create({
                    pusername: username,
                    ppassword: password,
					hid:work
                }, function(err, results) {
                
                    return callback(err,results);
                });
            
        


   
};

exports.selpatient = function(username,callback)
{
	Patient.find({pusername:username},function(err,patient)
		{
			  console.log(patient[0].pusername);
			return callback(err,patient[0]);
			
		})	
	
	
}

exports.selpatient2 = function(username,work,callback)
{
	Patient.find({pusername:username,hid:work},function(err,patient)
		{
			  console.log(patient[0].pusername);
			return callback(err,patient[0]);
			
		})	
	
	
}


