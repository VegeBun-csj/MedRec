
var express = require('express');
var router = express.Router();
var moment = require('moment');
var hospitalMedicine = require('../services/HospitalMedicine');
var mysql = require('mysql');

const path = require('path');
const fs = require('fs');
const configpath= path.join(__dirname, '../../config.json');
const configJson = fs.readFileSync(configpath,'utf-8');
const config = JSON.parse(configJson);
const password = config.dbpassword;
const database = config.database;


var connection = mysql.createConnection({
	host: "localhost",
	user: "root",
	password: password,
	database: database
});





router.get('/yaopingguanli',function(req,res,next)
{
	var hid  = req.query.hid;

    hospitalMedicine.getMedicine(hid,function(err,medicines)
    {
        //JSON.stringify(medicines);
        console.log(medicines[0].m_name);
       res.render('hospitalMedicine.ejs',{medicines:medicines});

    });
    

});



module.exports = router;
