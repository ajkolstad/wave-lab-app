/*
pages.js
Where most of the magic happens: Database connection, page serving, info insertion
Is utilized by server.js
*/
var express = require('express');
var router = express.Router();
router.use(require('cookie-parser')());
var env = require('dotenv');  /*  */
var jwt = require('jsonwebtoken');
var mysql = require('mysql');
const { VM } = require('handlebars');
var moment = require('moment');

//Loads database information from config.env
env.config({ path: './config.env'})

var directionalWaveBasinDepth = 0;
var largeWaveFlumeDepth = 0;

var directionalBasinTarget = 0;
var largeWaveFlumeTarget = 0;

//Loads database
var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});

//Connects to database
database.connect(function(error) {
    if(!!error) {
        console.log('[Router]  Error connecting to Database');
        console.log(error);
    } else {
        console.log('[Router]  Connected to Database');
    }
})

//Checks for presence of autheticated user cookies to allow admin access
function authenticateUser(req) {
    try {
        var username = req.cookies['username'];
        var password = req.cookies['password'];
        if (username && password) {
            console.log("[Webserver] User: \"" + username + "\" Authenticated");
            return true;
        } else {
            console.log("[Webserver] Authentication Failed: No User Found");
            return false;
        }

    } catch (error) {
        console.log("[Webserver] Authentication Failed: No User Found");
        return false;
    }
    return false;
}

router.get("/", async (req, res) => {
    directionalWaveBasinDepth = await getDepth(0);
    directionalWaveBasinTarget = await getTarget(0);
    largeWaveFlumeDepth = await getDepth(1);
    largeWaveFlumeTarget = await getTarget(1);


    var basinText = "";
    var flumeText = "";

    var basinProgText = "";
    var flumeProgText = "";

    if (directionalWaveBasinTarget == -1) {
        if (directionalWaveBasinDepth == "error") {
            basinText = "Error reading depth";
        } else {
            basinText = "Filled to " + directionalWaveBasinDepth + "m";
        }
            
        basinProgText = "Completed filling";
    } else if (directionalWaveBasinTarget == "error") {
        if (directionalWaveBasinDepth == "error") {
            basinText = "Error reading depth";
        } else {
            basinText = "Currently " + directionalWaveBasinDepth + "m";
        }
        basinProgText = "No job found";
    } else {
        if (directionalWaveBasinTarget == "error") {
            basinText = "Error reading depth";
        } else {
            basinText = "Currently " + directionalWaveBasinDepth + "m";
        }
        basinProgText = "Filling to " + directionalWaveBasinTarget + "m";
    }
    if (largeWaveFlumeTarget == -1) {
        if (largeWaveFlumeDepth == "error") {
            flumeText = "Error reading depth";
        } else {
            flumeText = "Filled to " + largeWaveFlumeDepth + "m";
        }
        flumeProgText = "Completed filling";
    } else if (largeWaveFlumeTarget == "error") {
        if (largeWaveFlumeDepth == "error") {
            flumeText = "Error reading depth";
        } else {
            flumeText = "Currently " + largeWaveFlumeDepth + "m";
        }
        flumeProgText = "No job found";
    } else {
        if (largeWaveFlumeDepth == "error") {
            flumeText = "Error reading depth";
        } else {
            flumeText = "Currently " + largeWaveFlumeDepth + "m";
        }
        flumeProgText = "Filling to " + largeWaveFlumeTarget + "m";
    }
    
    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin",
            basinDepth: basinText,
            flumeDepth: flumeText,
            basinProg: basinProgText,
            flumeProg: flumeProgText
        });
    } else {
        res.status(200).render(`layouts${req.url}`, {
            basinDepth: basinText,
            flumeDepth: flumeText,
            basinProg: basinProgText,
            flumeProg: flumeProgText
        });
    }
    
});

router.get("/logout", (req, res) => {
    try {
        res.clearCookie('username');
        res.clearCookie('password');
    } catch (error) {

    }
    res.status(200).render(`layouts${'/'}`);

});

router.get("/login", (req, res) => {
    res.status(200).render(`layouts${req.url}`);
});

router.get("/live", (req, res) => {
        res.status(200).render(`layouts${req.url}`);
});

router.get("/large-wave-flume", async (req, res) => {
    largeWaveFlumeDepth = await getDepth(1);
    largeWaveFlumeTarget = await getTarget(1);
    largeWaveFlumeTargetTime = await getTargetTime(1);
    largeWaveFlumeTargetUser = await getTargetUser(1);
    largeWaveFlumeTimeElasped = await getTargetTimeElapsed(1);
    graphDepths = await getDepths(1);
    graphTimes = await getDepthTimes(1);

    var flumeText = "";
    var flumeProgText = "";
    var flumeTimeText = "";
    var flumeUserText = "";
    var timeRemainingText = "";

    if (largeWaveFlumeTarget == -1) {
        if (largeWaveFlumeDepth == "error") {
            flumeText = "Error reading depth";
        } else {
            flumeText = "Filled to " + largeWaveFlumeDepth + "m";
        }
        flumeProgText = "Completed filling";
        flumeTimeText = "No time set";
        flumeUserText = "No user set";
    } else if (largeWaveFlumeTarget == "error") {
        if (largeWaveFlumeDepth == "error") {
            flumeText = "Error reading depth";
        } else {
            flumeText = "Currently " + largeWaveFlumeDepth + "m";
        }
        flumeProgText = "No job found";
        flumeTimeText = "Error finding time";
        flumeUserText = "Error finding user";
    } else {
        if (largeWaveFlumeDepth == "error") {
            flumeText = "Error reading depth";
        } else {
            flumeText = "Currently " + largeWaveFlumeDepth + "m";
        }
        flumeProgText = "Filling to " + largeWaveFlumeTarget + "m";
        flumeTimeText = "Set at " + largeWaveFlumeTargetTime;
        flumeUserText = "Set by " + largeWaveFlumeTargetUser;
        var time = (Number(largeWaveFlumeTarget) - Number(largeWaveFlumeDepth)) / 0.3048; //1 foot/hr = 0.3048m/hr
        var hours = Math.trunc(time);
        if (hours == 0) timeRemainingText = (60 * (time.toFixed(2) - hours)).toFixed(0) + " minutes remaining";
        else if (hours == 1) timeRemainingText = hours + " hour and " + (60 * (time.toFixed(2) - hours)).toFixed(0) + " minutes remaining";
        else timeRemainingText = hours + " hours and " + (60 * (time.toFixed(2) - hours)).toFixed(0) + " minutes remaining";
    }

    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin",
            flumeDepth: flumeText,
            flumeProg: flumeProgText,
            flumeTime: flumeTimeText,
            flumeTimeElapsed: "Fill started " + largeWaveFlumeTimeElasped,
            flumeUser: flumeUserText,
            depths:  graphDepths,
            times: graphTimes,
            timeRemaining: timeRemainingText
        });
    } else {
        res.status(200).render(`layouts${req.url}`, {
            flumeDepth: flumeText,
            flumeProg: flumeProgText,
            flumeTime: flumeTimeText,
            flumeTimeElapsed: "Fill started " + largeWaveFlumeTimeElasped,
            flumeUser: flumeUserText,
            depths: graphDepths,
            times: graphTimes,
            timeRemaining: timeRemainingText
        });
    }
});

router.get("/directional-wave-basin", async (req, res) => {
    directionalWaveBasinDepth = await getDepth(0);
    directionalWaveBasinTarget = await getTarget(0);
    directionalWaveBasinTargetTime = await getTargetTime(0);
    directionalWaveBasinTargetUser = await getTargetUser(0);
    directionalWaveBasinTimeElasped = await getTargetTimeElapsed(0);
    graphDepths = await getDepths(0);
    graphTimes = await getDepthTimes(0);

    var basinText = "";
    var basinProgText = "";
    var basinTimeText = "";
    var basinUserText = "";
    var timeRemainingText = "";

    if (directionalWaveBasinTarget == -1) {
        if (directionalWaveBasinDepth == "error") {
            basinText = "Error reading depth";
        } else {
            basinText = "Filled to " + directionalWaveBasinDepth + "m";
        }
            
        basinProgText = "Completed filling";
        basinTimeText = "No time set";
        basinUserText = "No user set";
    } else if (directionalWaveBasinTarget == "error") {
        if (directionalWaveBasinDepth == "error") {
            basinText = "Error reading depth";
        } else {
            basinText = "Currently " + directionalWaveBasinDepth + "m";
        }
        basinProgText = "No job found";
        basinTimeText = "Error finding time";
        basinUserText = "Error finding user";
    } else {
        if (directionalWaveBasinTarget == "error") {
            basinText = "Error reading depth";
        } else {
            basinText = "Currently " + directionalWaveBasinDepth + "m";
        }
        basinProgText = "Filling to " + directionalWaveBasinTarget + "m";
        basinTimeText = "Set at " + directionalWaveBasinTargetTime;
        basinUserText = "Set by " + directionalWaveBasinTargetUser;
        var time = (Number(directionalWaveBasinTarget) - Number(directionalWaveBasinDepth)) / 0.1524; //0.5 foot/hr = 0.1524m/hr
        var hours = Math.trunc(time);
        if (hours == 0) timeRemainingText = (60 * (time.toFixed(2) - hours)).toFixed(0) + " minutes remaining";
        else if (hours == 1) timeRemainingText = hours + " hour and " + (60 * (time.toFixed(2) - hours)).toFixed(0) + " minutes remaining";
        else timeRemainingText = hours + " hours and " + (60 * (time.toFixed(2) - hours)).toFixed(0) + " minutes remaining";
    }

    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin",
            basinDepth: basinText,
            basinProg: basinProgText,
            basinTime: basinTimeText,
            basinTimeElapsed: "Fill started " + directionalWaveBasinTimeElasped,
            basinUser: basinUserText,
            depths:  graphDepths,
            times: graphTimes,
            timeRemaining: timeRemainingText
        });
    } else {
        res.status(200).render(`layouts${req.url}`, {
            basinDepth: basinText,
            basinProg: basinProgText,
            basinTime: basinTimeText,
            basinTimeElapsed: "Fill started " + directionalWaveBasinTimeElasped,
            basinUser: basinUserText,
            depths:  graphDepths,
            times: graphTimes,
            timeRemaining: timeRemainingText
        });
    }
});

async function getDepth(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 0 ORDER BY Ddate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Depth);
                });
            } catch (error) {
                resolve("error");
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 1 ORDER BY Ddate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Depth);
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

async function getDepths(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT Depth FROM `depth_data` WHERE Depth_Flume_Name = 0 ORDER BY Ddate ASC',(error, results) => {
                    
                    array = [];
                    Object.keys(results).forEach(function(key) {
                        var row = results[key];
                        array.push(Number(row.Depth));
                    });
                    resolve(array);
                });
            } catch (error) {
                resolve("error");
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT Depth FROM `depth_data` WHERE Depth_Flume_Name = 1 ORDER BY Ddate ASC',(error, results) => {
                    array = [];
                    Object.keys(results).forEach(function(key) {
                        var row = results[key];
                        array.push(Number(row.Depth));
                    });
                    resolve(array);
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

async function getDepthTimes(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT Ddate FROM `depth_data` WHERE Depth_Flume_Name = 0 ORDER BY Ddate ASC',(error, results) => {
                    array = [];
                    Object.keys(results).forEach(function(key) {
                        var row = results[key];
                        array.push(new Date(row.Ddate).toLocaleTimeString('en-US', { hour12: false }));
                    });
                    resolve(array);
                });
            } catch (error) {
                resolve("error");
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT Ddate FROM `depth_data` AS DATE WHERE Depth_Flume_Name = 1 ORDER BY Ddate ASC',(error, results) => {
                    array = [];
                    Object.keys(results).forEach(function(key) {
                        var row = results[key];
                        array.push(new Date(row.Ddate).toLocaleTimeString('en-US', { hour12: false }));
                    });
                    resolve(array);
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

async function getTarget(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    else if (results[0].isComplete == 1) resolve(-1);
                    else resolve(results[0].Tdepth);
                });
            } catch (error) {
                resolve("error");
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    else if (results[0].isComplete == 1) resolve(-1);
                    else resolve(results[0].Tdepth);
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

async function getTargetTime(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Tdate);
                });
            } catch (error) {
                resolve("error");
                
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Tdate);
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

async function getTargetTimeElapsed(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    var start = moment(results[0].Tdate);
                    resolve(start.fromNow())
                });
            } catch (error) {
                resolve("error");
                
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    var start = moment(results[0].Tdate);
                    resolve(start.fromNow())
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

async function getTargetUser(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Username);
                });
            } catch (error) {
                resolve("error");
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `target_depth` WHERE Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Username);
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

module.exports = router;