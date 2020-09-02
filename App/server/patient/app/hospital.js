
var express = require('express');
var router = express.Router();
var moment = require('moment');
var hospitalMedicine = require('../services/HospitalMedicine');

var mysql = require('mysql');
var bodyParser = require('body-parser');
var connection = mysql.createConnection({
	host: "localhost",
	user: "root",
	password: "louise",
	database: "bishe2"
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
