var express = require('express');
var authController = require('../controllers/auth');
//var targetController = require('../controllers/target');
var router = express.Router();

router.post("/login", authController.login);

router.post("/large-wave-flume", authController.postLWF);

router.post("/directional-wave-basin", authController.postDWB);

module.exports = router;