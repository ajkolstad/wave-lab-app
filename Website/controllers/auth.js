var mysql = require('mysql');
var env = require('dotenv');
var jwt = require('jsonwebtoken');
var moment = require('moment');


env.config({ path: './config.env'})

var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});


exports.login = async (req, res) => {
    try {
        console.log("about to get data");
        var {username, password} = req.body;
        console.log("Just got data");

        if(!username || !password) {
            return res.status(400).render('layouts.login', {
                message: 'Please enter an Username and Password'
            })
        }
        console.log("[Webserver] User: \"" + username + "\" attempting login...");
        database.query('SELECT * FROM user WHERE username = ?',[username], async (error, results) => {
            console.log("[Database]  Checking for Username: " + username);
            //console.log(results);
            if(results.length < 1) {
                    res.status(401).render(`layouts${"/login"}`, {
                        message: 'Incorrect Username or Password'
                    });
                    console.log("[Database]  Username " + username + " not found");
            } else if(password != results[0].Password) {
                res.status(401).render(`layouts${"/login"}`, {
                    message: 'Incorrect Username or Password'
                });
                console.log("[Webserver] Incorrect password for Username: " + username);
            } else {
                console.log("[Webserver] Login successful")
                var id = results[0].Username;
                //console.log("Username: " + id);
               // var token = jwt.sign({ id }, process.env.JWT_SECRET, {
               //     expiresIn: process.env.JWT_EXPIRES_IN
               // });
                //console.log("Token: " + token);
                var cookieOptions = {
                    expires: new Date(
                        Date.now() + process.env.JWT_COOKIE_EXPIRES * 24 * 60 * 60 * 1000
                    ),
                    httpOnly: true
                };
                console.log("[Webserver] Cookie created for User: " + username);
                res.cookie('password', password, cookieOptions);
                res.cookie('username', username, cookieOptions);
                res.status(200).render(`layouts${'/'}`, {
                    message: "admin"
                });
            }
        });
    } catch (error) {
        res.status(401).render(`layouts${"/login"}`, {
            message: 'Incorrect Username or Password'
        });
    }
};

exports.postLWF = async (req, res) => {
    try {
        var {depthTarget, timeOffset} = req.body;

        console.log("[Webserver] New Depth Request - Target: " + depthTarget + " Offset: " + timeOffset);
        var newTime = Date.now();
        var addTime = moment(newTime).add(timeOffset, 'hours').format('YYYY-MM-DD hh:mm:ss');
        var username = req.cookies['username'];
        var flumeName = 1; //for LWF
        var isComplete = 0;
        console.log("[Webserver] New Depth Request: " + depthTarget + " LWF " + addTime + " " + username + " 0");
        database.query('INSERT INTO target_depth (Tdepth, Target_Flume_Name, Tdate, Username, isComplete) VALUES (?,?,?,?,?)',[depthTarget, flumeName, addTime, username, isComplete], async (error, results) => {
            console.log("[Webserver] Depth Request Added");
        });
    } catch (error) {
        console.log("[Webserver] Failed To Add Depth Request");
    }
};

exports.postDWB = async (req, res) => {
    try {
        var {depthTarget, timeOffset} = req.body;

        console.log("[Webserver] New Depth Request - Target: " + depthTarget + " Offset: " + timeOffset);
        var newTime = Date.now();
        var addTime = moment(newTime).add(timeOffset, 'hours').format('YYYY-MM-DD hh:mm:ss');
        var username = req.cookies['username'];
        var flumeName = 0; //for DWB
        var isComplete = 0;
        console.log("[Webserver] New Depth Request: " + depthTarget + " LWF " + addTime + " " + username + " 0");
        database.query('INSERT INTO target_depth (Tdepth, Target_Flume_Name, Tdate, Username, isComplete) VALUES (?,?,?,?,?)',[depthTarget, flumeName, addTime, username, isComplete], async (error, results) => {
            console.log("[Webserver] Depth Request Added");
        });
    } catch (error) {
        console.log("[Webserver] Failed To Add Depth Request");
    }
};