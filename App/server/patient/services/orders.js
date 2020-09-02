var Orders = require('../models/orders');
var uuid = require('../config/uuid');


exports.xiadan = function(order_count,order_price,hid,pid,mid,callback)
{
    function uuid(len, radix) {
        var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
        var uuid = [], i;
        radix = radix || chars.length;
     
        if (len) {
          // Compact form
          for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
        } else {
          // rfc4122, version 4 form
          var r;
     
          // rfc4122 requires these characters
          uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
          uuid[14] = '4';
     
          // Fill in random data.  At i==19 set the high bits of clock sequence as
          // per rfc4122, sec. 4.1.5
          for (i = 0; i < 36; i++) {
            if (!uuid[i]) {
              r = 0 | Math.random()*16;
              uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
            }
          }
        }
     
        return uuid.join('');
    }

        var uuid = uuid(12,16);
        console.log(pid);
        console.log('uuid: '+uuid);
        var order_date = new Date().toISOString().slice(0, 19).replace('T', ' ');
        var status;
   
            Orders.create({
                order_count: order_count,
                order_price: order_price,
                order_date:order_date,
                hid:hid,
                pid:pid,
                mid: mid,
                order_status:0,
                order_code:uuid
            }, function(err) {
            
                if(err)
                {
                    console.log(err);
                    status = 0;
                    return callback(status);
                }else{


                    
                    status = 1;
                    return callback(status);
                }
                
            });
    
}
