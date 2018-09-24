console.log("Decrypting my FC4ME Security String");
const encryp = require('./41.js');
var datestr = "Monday 24th of September 2018"
var fc4meconst = "\x74\x72\x79\x68\x61\x72\x64\x65\x72"
var finalfc4str = fc4meconst + datestr;
//console.log(`The Enc value is ${encryp.hexMD5(finalfc4str)}`);
var securityString = encryp.hexMD5(finalfc4str);
console.log(securityString)
