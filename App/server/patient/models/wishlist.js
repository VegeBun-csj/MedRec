
var db = require('./mysql');

var wishlist = {

    wish_id: { type: 'serial', key: true } , //主键
   
    pid: {type: 'integer'},
    mid: {type: 'integer'},
   
};

var Wishlist = db.define('wishlist',wishlist);

module.exports = Wishlist;