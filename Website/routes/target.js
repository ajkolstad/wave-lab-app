var express = require('express');
var targetController = require('../controllers/target');
var router = express.Router();

router.post("/large-wave-flume", targetController.postLWF);

//router.post("/directional-wave-basin", authController.postDWB);

module.exports = router;