
var db = require('./mysql');

var orders = {

    mid: {type: 'integer'},
    pid: {type: 'integer'},
    order_date:String,
    order_price: Number,
    order_count: {type: 'integer'},
    oid: { type: 'serial', key: true } , //主键
    hid: {type: 'integer'},
    order_code:String,
    order_status:{type:'integer'}
};

var Orders = db.define('orders',orders);

module.exports = Orders;