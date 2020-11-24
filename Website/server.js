var path = require('path');
var express = require('express');
var port = process.env.PORT || 3000;
var exphbs = require('express-handlebars');
var mysql = require('mysql');
var app = express();
var env = require('dotenv');
var cookieParser = require('cookie-parser');
var tools = require("./monitor/target.js");


app.use(cookieParser());

env.config({ path: './config.env'})




var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});

database.connect(function(error) {
    if(!!error) {
        console.log('[Database]  Error connecting to Database');
        console.log(error);
    } else {
        console.log('[Database]  Connected to Database');
    }

    tools.check_complete(0);
    tools.check_complete(1);
})

app.use(express.urlencoded({ extended: false}));

app.use(express.json());



app.engine('handlebars', exphbs({ 
    defaultLayout: 'main',
}));

app.set('view engine', 'handlebars');

app.use(express.static('public'));

app.listen(port, function () {
  console.log("[Webserver] Server listening on port ", port);
});




///Routes
app.use('/', require('./routes/pages'));
app.use('/auth', require('./routes/auth'));




/*
app.get('*', (req, res, next) => {
    if(req.url.endsWith('/')) req.url = req.url.substring(0, req.url.length - 1);
    res.status(200).render(`layouts${req.url}`, (err, html) => {
        if(err) {
            res.status(404).render('404', {
                err: "Page not Found.",
                errNum: 404
            });
            return;
        }
        res.send(html);
    });
});
*/
