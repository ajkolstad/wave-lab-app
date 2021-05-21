/*
server.js
The heart of the webserver (well it is the webserver, really)

Connects to database and uses helper functions to serve content to users
*/


var path = require('path');
var express = require('express');
var port = process.env.PORT || 3000;
var exphbs = require('express-handlebars');
var mysql = require('mysql');
var app = express();
var env = require('dotenv');
var cookieParser = require('cookie-parser');

//Required for expressjs
app.use(express.urlencoded({ extended: false}));

//Required for expressjs
app.use(express.json());


//Means that we are using the handlebars templating engine with express
app.engine('handlebars', exphbs({ 
    defaultLayout: 'main',
}));

app.set('view engine', 'handlebars');

app.use(express.static('public'));


//Webserver starts listening on defined port
app.listen(port, function () {
  console.log("[Webserver] Server listening on port ", port);
});


///Routes used for helping server.js
app.use('/', require('./routes/pages'));    //Used for adding info to pages, like database info
app.use('/auth', require('./routes/auth')); //Used for authenticating with database for sign in as an administrator