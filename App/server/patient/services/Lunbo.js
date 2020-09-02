
var Lunbo = require("../models/lunbo");

var db = require("../models/mysql");



exports.selLunbo = function(lunbo_id,callback)
{
	console.log(lunbo_id);
	Lunbo.find({lunbo_id:lunbo_id},function(err,lunbo)
		{
			  console.log(lunbo.news_title);
			return callback(err,lunbo);
			
		})	
	
	
}




