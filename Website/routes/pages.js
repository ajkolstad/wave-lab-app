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
})



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
        basinProgText = "Filling to " + directionalWaveBasinTarget;
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
        flumeProgText = "Filling to " + largeWaveFlumeTarget;
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
        res.status(200).render(`layouts${req.url}`);
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

router.get("/large-wave-flume", (req, res) => {
    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin"
        });
    } else {
        res.status(200).render(`layouts${req.url}`);
    }
});

router.get("/directional-wave-basin", (req, res) => {
    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin"
        });
    } else {
        res.status(200).render(`layouts${req.url}`);
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