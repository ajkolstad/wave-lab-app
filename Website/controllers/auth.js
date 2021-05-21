/*
auth.js
Handles logging in and posting new depth requests
*/
var mysql = require('mysql');
var env = require('dotenv');
var jwt = require('jsonwebtoken');
var moment = require('moment');

//Loads database information from config.env
env.config({ path: './config.env'})

//Loads database
var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});

//Completes login of user
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
                var cookieOptions = {
                    expires: new Date(
                        Date.now() + process.env.JWT_COOKIE_EXPIRES * 24 * 60 * 60 * 1000
                    ),
                    httpOnly: true
                };
                console.log("[Webserver] Cookie created for User: " + username);
                res.cookie('password', password, cookieOptions);
                res.cookie('username', username, cookieOptions);
                res.redirect('/');
            }
        });
    } catch (error) {
        res.status(401).render(`layouts${"/login"}`, {
            message: 'Incorrect Username or Password'
        });
    }
};

//Posts large wave flume depth request to database
exports.postLWF = async (req, res) => {
    try {
        var {depthTarget, timeOffset} = req.body;
        console.log("[Webserver] New Depth Request - Target: " + depthTarget + " Offset: " + timeOffset);
        var newTime = Date.now();
        var addTime = moment(newTime).add(timeOffset, 'hours').format('YYYY-MM-DD HH:mm:ss');
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
    res.redirect(req.get('referer'));
};

//Starts filling large wave flume
exports.startLWF = async (req, res) => {
    try {
        var depthTarget = 5;
        var timeOffset = 0;
        console.log("[Webserver] Starting LWF Fill - Target: " + depthTarget + " Offset: " + timeOffset);
        var newTime = Date.now();
        var addTime = moment(newTime).add(timeOffset, 'hours').format('YYYY-MM-DD HH:mm:ss');
        var username = req.cookies['username'];
        var flumeName = 1; //for LWF
        var isComplete = 0;
        console.log("[Webserver] New Depth Request: " + depthTarget + " LWF " + addTime + " " + username + " 0");
        database.query('INSERT INTO target_depth (Tdepth, Target_Flume_Name, Tdate, Username, isComplete) VALUES (?,?,?,?,?)',[depthTarget, flumeName, addTime, username, isComplete], async (error, results) => {
            console.log("[Webserver] Depth Request Added");
        });
    } catch (error) {
        console.log("[Webserver] Failed To Start LWF Fill");
    }
    res.redirect(req.get('referer'));
};

//Stopps filling large wave flume
exports.stopLWF = async (req, res) => {
    try {
        console.log("[Webserver] Stopping LWF Fill")
        database.query('UPDATE target_depth SET isComplete = 1 WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1', async (error, results) => {
            console.log("[Webserver] Stopped LWF Fill");
        });
    } catch (error) {
        console.log("[Webserver] Failed To Stop LWF Fill");
    }
    res.redirect(req.get('referer'));
};

//Posts directional wave basin depth request to database
exports.postDWB = async (req, res) => {
    try {
        var {depthTarget, timeOffset} = req.body;
        console.log("[Webserver] New Depth Request - Target: " + depthTarget + " Offset: " + timeOffset);
        var newTime = Date.now();
        var addTime = moment(newTime).add(timeOffset, 'hours').format('YYYY-MM-DD HH:mm:ss');
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
    res.redirect(req.get('referer'));
};

//Starts filling directional wave basin
exports.startDWB = async (req, res) => {
    try {
        var depthTarget = 5;
        var timeOffset = 0;
        console.log("[Webserver] Starting DWB Fill - Target: " + depthTarget + " Offset: " + timeOffset);
        var newTime = Date.now();
        var addTime = moment(newTime).add(timeOffset, 'hours').format('YYYY-MM-DD HH:mm:ss');
        var username = req.cookies['username'];
        var flumeName = 0; //for DWB
        var isComplete = 0;
        console.log("[Webserver] New Depth Request: " + depthTarget + " LWF " + addTime + " " + username + " 0");
        database.query('INSERT INTO target_depth (Tdepth, Target_Flume_Name, Tdate, Username, isComplete) VALUES (?,?,?,?,?)',[depthTarget, flumeName, addTime, username, isComplete], async (error, results) => {
            console.log("[Webserver] Depth Request Added");
        });
    } catch (error) {
        console.log("[Webserver] Failed To Start DWB Fill");
    }
    res.redirect(req.get('referer'));
};

//Stopps filling directional wave basin
exports.stopDWB = async (req, res) => {
    try {
        console.log("[Webserver] Stopping DWB Fill")
        database.query('UPDATE target_depth SET isComplete = 1 WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0', async (error, results) => {
            console.log("[Webserver] Stopped DWB Fill");
        });
    } catch (error) {
        console.log("[Webserver] Failed To Stop DWB Fill");
    }
    res.redirect(req.get('referer'));
};