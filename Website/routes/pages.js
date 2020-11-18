var express = require('express');
var router = express.Router();

router.get("/", (req, res) => {
    res.status(200).render(`layouts${req.url}`);
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