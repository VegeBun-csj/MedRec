var db = require('./mysql');

var lunbo = {
  	
	lunbo_id:{type:'integer'},
	news_title:String,
	news_date:String,
	news_content:String

};

var Lunbo = db.define('lunbo',lunbo);
module.exports = Lunbo;


