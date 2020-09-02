// config/passport.js

// load all the things we need
var LocalStrategy   = require('passport-local').Strategy;

// load up the user model
var mysql = require('mysql');
var bcrypt = require('bcrypt-nodejs');

//connecting to mysql
var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'louise',
  database: 'bishe2'
}); 

//testting connection to database
connection.connect(function(err) {
  if 
    (err) console.log(err)
  else
    console.log('connection is successful...')
});

// expose this function to our app using module.exports
module.exports = function(passport) {

    // =========================================================================
    // passport session setup ==================================================
    // =========================================================================
    // required for persistent login sessions
    // passport needs ability to serialize and unserialize users out of session

    // used to serialize the user for the session
    passport.serializeUser(function(user, done) {
        done(null, user.id);
    });

    // used to deserialize the user
    passport.deserializeUser(function(id, done) {
        connection.query("SELECT * FROM user WHERE id = ? ",[id], function(err, rows){
            done(err, rows[0]);
        });
    });

    

    // =========================================================================
    // LOCAL LOGIN =============================================================
    // =========================================================================
    // we are using named strategies since we have one for login and one for signup
    // by default, if there was no name, it would just be called 'local'

    passport.use(
        'local-login',
        new LocalStrategy({
            // by default, local strategy uses username and password, we will override with email
            usernameField : 'username',
            passwordField : 'password',
            passReqToCallback : true // allows us to pass back the entire request to the callback
        },
        function(req, username, password, done) { // callback with email and password from our form
            connection.query("SELECT * FROM hospital WHERE husername = ?",[username], function(err, rows){
                if (err)
                    return done(err);
                if (!rows.length) {
                    return done(null, false, req.flash('loginMessage', 'No user found.')); // req.flash is the way to set flashdata using connect-flash
                }

                // if the user is found but the password is wrong
                else if (!(password == rows[0].hpassword)) {
                    return done(null, false, req.flash('loginMessage', 'Oops! Wrong password.')); // create the loginMessage and save it to session as flashdata
                }
                // all is well, return successful user
                else {
                    console.log(rows[0].hid)
                    connection.query("SELECT * FROM user WHERE id = ?", rows[0].userid, function (err, rows1) {
                        return done(null, rows1[0]);
                    });
                }
            });
        })
    );
};
