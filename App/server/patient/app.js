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
var app  = express();
const publicpath = path.join(__dirname,'..','public');

// configuration ===============================================================
// connect to our database



// set up our express application
app.use(morgan('dev')); // log every request to the console
app.use(cookieParser()); // read cookies (needed for auth)
app.use(bodyParser.urlencoded({

    extended: true

}));
app.use(bodyParser.json());
app.use('/',express.static(publicpath));
app.use(favicon(path.join(publicpath, 'patient', 'favicon.ico')));

app.set('view engine', 'ejs'); // set up ejs for templating

// required for passport
app.use(session({
    secret: 'keyboard cat',
    resave: true,
    saveUninitialized: true
} )); // session secret
app.use(flash()); // use connect-flash for flash messages stored in session
app.use(require("express-domain-middleware"));


// routes ======================================================================
app.use('/patient',require('./app/patient.js'));
app.use('/',require('./app/admin.js'));
app.use('/hospital',require('./app/hospital.js'));
// launch ======================================================================
//Setting server port
app.listen(8081, function () {
    console.log("Server has started at 8081 port !!!");
});
