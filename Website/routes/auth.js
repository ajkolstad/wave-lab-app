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
router.post("/large-wave-flume-add", authController.postLWF);

//Bind large wave flume start fill button to function
router.post("/large-wave-flume-start", authController.startLWF);

//Bind large wave flume stop fill button to function
router.post("/large-wave-flume-stop", authController.stopLWF);

//Binds post directional wave basin depth request button to function
router.post("/directional-wave-basin-add", authController.postDWB);

//Binds directional wave basin start fill button to function
router.post("/directional-wave-basin-start", authController.startDWB);

//Binds directional wave basin stop fill button to function
router.post("/directional-wave-basin-stop", authController.stopDWB);

//Allows other functions to use auth.js' functions
module.exports = router;