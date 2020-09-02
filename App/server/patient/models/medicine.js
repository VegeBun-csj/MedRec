var db = require('./mysql');

var medicine = {
   
    m_type: String,
    hid: {type: 'integer'},
    mid: { type: 'serial', key: true},
    m_name: String,
    m_num: {type: 'integer'},
    m_price: Number,
    m_status: {type: 'integer'},
    m_picture: String,
    m_gongneng:String,
    m_guige:String,
    m_yongfa:String,
    m_buliangfanying:String,
    m_youxiaoqi:String,
    m_producerName:String,
    m_producerAddress:String,
    m_wenhao:String,
    m_chengfen:String

};

var Medicine = db.define('medicine',medicine);
module.exports = Medicine;


