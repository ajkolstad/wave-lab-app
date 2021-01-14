var mysql = require('mysql');
var env = require('dotenv');
var jwt = require('jsonwebtoken');


env.config({ path: './config.env'})

var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});

exports.postLWF = async (req, res) => {
    try {
        console.log("about to get data");
        var {depthTarget, timeOffset} = req.body;
        console.log("Just got data");

        if(!depthTarget || !timeOffset) {
            //return res.status(400).render(`layouts${"/large-wave-flume"}`, {
           //     message: 'Please enter a depth target'
            //});
        }
        console.log("[Webserver] Depth target" + depthTarget + " Time offset: " + timeOffSet);
        
    } catch (error) {
        console.log("Failed");
    }
};