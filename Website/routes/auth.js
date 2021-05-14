/*
auth.js
Routes the buttons in webpages used for login and posting depth
requests to functions within /controllers/auth
*/
var express = require('express');
var authController = require('../controllers/auth');
var router = express.Router();

//binds login button to login function
router.post("/login", authController.login);

//Binds post large wave flume depth request button to function
router.post("/large-wave-flume", authController.postLWF);

//Binds post directional wave basin depth request button to function
router.post("/directional-wave-basin", authController.postDWB);

//Allows other functions to use auth.js' functions
module.exports = router;