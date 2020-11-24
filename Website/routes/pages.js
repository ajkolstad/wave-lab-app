var express = require('express');
var router = express.Router();
router.use(require('cookie-parser')());
var env = require('dotenv');
var jwt = require('jsonwebtoken');
var mysql = require('mysql');

env.config({ path: './config.env'})

var directionalWaveBasinDepth = 0;
var largeWaveFlumeDepth = 0;

var directionalBasinTarget = 0;
var largeWaveFlumeTarget = 0;

var monitor = [0, 0];
var CHECK_DB_INTERVAL = 10000;          //amount of time in ms to wait before checking for target fill

var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});

database.connect(function(error) {
    if(!!error) {
        console.log('[Router]  Error connecting to Database');
        console.log(error);
    } else {
        console.log('[Router]  Connected to Database');
    }

    //when db connect, if monitor isnt running monitor[x] == 0, spin up monitor function
    if(!monitor[0])
    {
        check_complete(0);
    }
    if(!monitor[1])
    {
        check_complete(1);
    }
})

/*INSERT INTO `target_depth`(`Tdepth`, `Target_Flume_Name`, `Tdate`, `Username`, `isComplete`) VALUES ("2.78","1",CURRENT_TIMESTAMP(),"ajkolstad","0")*/

function authenticateUser(req) {
    try {
        var username = req.cookies['username'];
        var password = req.cookies['password'];
        //console.log("[Webserver] User: \"" + username + "\" Authenticating...");
        //var calcToken = jwt.sign({ username }, process.env.JWT_SECRET, {
        //    expiresIn: process.env.JWT_EXPIRES_IN
        //});
        //console.log("Calctoken: " + calcToken);
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
    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin"
        });
    } else {
        res.status(200).render(`layouts${req.url}`);
    }
});

router.get("/large-wave-flume", async (req, res) => {
    largeWaveFlumeDepth = await getDepth(1);
    largeWaveFlumeTarget = await getTarget(1);
    largeWaveFlumeTargetTime = await getTargetTime(1);
    largeWaveFlumeTargetUser = await getTargetUser(1);

    var flumeText = "";
    var flumeProgText = "";
    var flumeTimeText = "";
    var flumeUserText = "";

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
    }
    
    
    

    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin",
            flumeDepth: flumeText,
            flumeProg: flumeProgText,
            flumeTime: flumeTimeText,
            flumeUser: flumeUserText
        });
    } else {
        res.status(200).render(`layouts${req.url}`, {
            flumeDepth: flumeText,
            flumeProg: flumeProgText,
            flumeTime: flumeTimeText,
            flumeUser: flumeUserText
        });
    }
});

router.get("/directional-wave-basin", async (req, res) => {
    directionalWaveBasinDepth = await getDepth(0);
    directionalWaveBasinTarget = await getTarget(0);
    directionalWaveBasinTargetTime = await getTargetTime(0);
    directionalWaveBasinTargetUser = await getTargetUser(0);

    var basinText = "";
    var basinProgText = "";
    var basinTimeText = "";
    var basinUserText = "";

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
    }

    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin",
            basinDepth: basinText,
            basinProg: basinProgText,
            basinTime: basinTimeText,
            basinUser: basinUserText
        });
    } else {
        res.status(200).render(`layouts${req.url}`, {
            basinDepth: basinText,
            basinProg: basinProgText,
            basinTime: basinTimeText,
            basinUser: basinUserText
        });
    }
});

module.exports = router;

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

function sleep(ms)
{
    return new Promise(resolve => setTimeout(resolve, ms));
}

//looping function for monitoring a fill target
async function check_complete(flumeNumber)
{
    switch (flumeNumber)
    {
        case 0:
            console.log("[Monitor][DWB] Starting...");
            break;
        case 1:
            console.log("[Monitor][LWF] Starting...");
            break;
    }

    //mutex-ish lock to prevent an army of monitor funcs
    monitor[flumeNumber] = 1;
    while(monitor[flumeNumber] == 1)
    {
        var check = await isComplete(flumeNumber);
        switch (check)
        {
            case 1:
                monitor[flumeNumber] = 0;
                    console.log("ending");
                break;
            case -1:
                console.log("monitor spun up with wrong flume number")
                break;
            default:
                //console.log(flumeNumber + " not yet complete");
                break;
        }

        //wait interval before checking again
        await sleep(CHECK_DB_INTERVAL);
    }
    switch (flumeNumber)
    {
        case 0:
            console.log("[Monitor][DWB] Ended");
            break;
        case 1:
            console.log("[Monitor][LWF] Ended");
            break;
    }
}

async function isComplete(flumeNumber) {
    if(flumeNumber != 0 && flumeNumber != 1)
    {
        return -1;
    }
    switch (flumeNumber)
    {
        case 0:
            var current_depth = await getDepth(flumeNumber);

            //check for if therer is a 
            database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                if(error) throw error;
                if(results < 1)
                {
                    //no planned fill target
                    return 1;
                }
                else
                {
                    //planned target fill, now check if current level meets target level
                    database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                        if (error) throw error;
                        if(results[0].Tdepth > current_depth)
                        {
                            //not complete
                            console.log("[Monitor][DWB] " + results[0].Tdepth + " > " + current_depth);
                        }
                        else if(results[0].Tdepth <= current_depth)
                        {
                            //already complete
                            console.log("[Monitor][DWB] Fill target: " + results[0].Tdepth + " complete");

                            var update_high = results[0].Tdepth + .01;
                            var update_low = results[0].Tdepth - .01;

                            database.query('UPDATE target_depth SET isComplete = 1 WHERE Tdepth > ? AND Tdepth < ?', [update_low, update_high], (error, results) => {
                                if(error) throw error;
                            });
                            
                            //return loop exit response
                            monitor[0] = 0;
                        }
                    });
                }
            });
            break;
        case 1:
            var current_depth = await getDepth(flumeNumber);
            database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 AND isComplete = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                if(error) throw error;
                if(results < 1)
                {
                    //no planned fill target
                    return 1;
                }
                else
                {
                    //planned target fill, now check if current level meets target level
                    database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                        if (error) throw error;
                        if(results[0].Tdepth > current_depth)
                        {
                            //not complete
                            console.log("[Monitor][LWF] " + results[0].Tdepth + " > " + current_depth);
                        }
                        else if(results[0].Tdepth <= current_depth)
                        {
                            //already complete
                            console.log("[Monitor][LWF] Fill target: " + results[0].Tdepth + " complete");

                            var update_high = results[0].Tdepth + .01;
                            var update_low = results[0].Tdepth - .01;

                            database.query('UPDATE target_depth SET isComplete = 1 WHERE Tdepth > ? AND Tdepth < ?', [update_low, update_high], (error, results) => {
                                if(error) throw error;
                            });
                            
                            //return loop exit response
                            monitor[1] = 0;
                        }
                    });
                }
            });
            break;
    }
    return 0;
}