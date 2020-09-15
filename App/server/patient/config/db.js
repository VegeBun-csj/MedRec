

const path = require('path');
const fs = require('fs');
const configpath= path.join(__dirname, '../../config.json');
const configJson = fs.readFileSync(configpath,'utf-8');
const config = JSON.parse(configJson);
const password = config.dbpassword;
const database = config.database;


var db = {

    host: 'localhost',
    user: 'root',
    password: password,
    database: database,
    port: 3306

};

module.exports = db;
