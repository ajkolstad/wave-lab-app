var express = require('express');
var router = express.Router();
router.use(require('cookie-parser')());
var env = require('dotenv');
var jwt = require('jsonwebtoken');


env.config({ path: './config.env'})

function authenticateUser(req) {
    try {
        var username = req.cookies['username'];
        var password = req.cookies['password'];
        console.log("Username: " + username + " password: " + password + "\n");
        //var calcToken = jwt.sign({ username }, process.env.JWT_SECRET, {
        //    expiresIn: process.env.JWT_EXPIRES_IN
        //});
        //console.log("Calctoken: " + calcToken);
        if (username && password) {
            return true;
        } else {
            return false;
        }

    } catch (error) {
        console.log("failed");
        return false;
    }
    return false;
}


router.get("/", (req, res) => {
    if (authenticateUser(req)) {
        res.status(200).render(`layouts${req.url}`, {
            message: "admin"
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
    res.status(200).render(`layouts${req.url}`);
});

router.get("/large-wave-flume", (req, res) => {

    res.status(200).render(`layouts${req.url}`);
});

router.get("/directional-wave-basin", (req, res) => {
    res.status(200).render(`layouts${req.url}`);
});

module.exports = router;