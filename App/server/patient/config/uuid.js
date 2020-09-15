function uuid(len, radix) {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    var uuid = [], i;
    radix = radix || chars.length;
 
    if (len) {
      // Compact form
      for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
    } else {
      var r;
      uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
      uuid[14] = '4';
 
      for (i = 0; i < 36; i++) {
        if (!uuid[i]) {
          r = 0 | Math.random()*16;
          uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
        }
      }
    }
 
    return uuid.join('');
}
// 这个可以指定长度和基数。比如

// // 8 character ID (base=2)
// uuid(8, 2)  //  "01001010"
// // 8 character ID (base=10)
// uuid(8, 10) // "47473046"
// // 8 character ID (base=16)
// uuid(8, 16) // "098F4D35"
var uuid = uuid(8,16);
module.exports = uuid;
