// app.js

// set up ======================================================================
// get all the tools we need
var express  = require('express');
var session  = require('express-session');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var morgan = require('morgan');
var favicon = require('serve-favicon');
var path = require('path');
var passport = require('passport');
var flash    = require('connect-flash');
var app      = express();
var formidable = require('formidable');
const officegen = require('officegen');
const docx = officegen ('docx');
const fs    = require('fs');

//var moment = require("moment");



//docx.on ('finalize', function (written) {
//    console.log ('Finish to create Word file.\nTotal bytes created: ' + written + '\n');
//});
//docx.on ('error', function (err) {
//    console.log(err);
//});
//var textarr=['第1行','第2行','第3行','第4行'];
//for(var j=0;j<textarr.length;j++){
//    var pcontent=textarr[j];
 //   var pObj = docx.createP();
 //   pObj.addText (pcontent, { font_face: 'Arial', font_size: 14 });
//}
//var out = fs.createWriteStream ('./test.docx');
//out.on ('error', function (err) {
//    res.send(err);
//});
//docx.generate (out);


// configuration ===============================================================
// connect to our database

require('./config/passport')(passport); // pass passport for configuration



// set up our express application
app.use(morgan('dev')); // log every request to the console
app.use(cookieParser()); // read cookies (needed for auth)
app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());
app.use('/',express.static('/home/songjian/go/src/github.com/hyperledger/MedRec/App/server/public/'));
app.use(favicon(path.join('/home/songjian/go/src/github.com/hyperledger/MedRec/App/server/public/', 'hosp', 'favicon.ico')));


app.set('view engine', 'ejs'); // set up ejs for templating

// required for passport
app.use(session({
	secret: 'keyboard cat',
	resave: true,
	saveUninitialized: true
 } )); // session secret
app.use(passport.initialize());
app.use(passport.session()); // persistent login sessions
app.use(flash()); // use connect-flash for flash messages stored in session
app.use(require("express-domain-middleware"));


// routes ======================================================================
require('./app/routes.js')(app, passport); // load our routes and pass in our app and fully configured passport

// launch ======================================================================
//Setting server port
app.listen(3000, function () {
	console.log("Server has started!!!");
});
