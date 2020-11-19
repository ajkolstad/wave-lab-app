var mysql = require('mysql');
var env = require('dotenv');


env.config({ path: './config.env'})

var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});


exports.login = async (req, res) => {
    try {
        var {username, password} = req.body;

        if(!username || !password) {
            return res.status(400).render('layouts.login', {
                message: 'Please enter an Username and Password'
            })
        }
        database.query('SELECT * FROM user WHERE username = ?',[username], async (error, results) => {
            console.log(results);
            console.log("yeet1");
            if(!results || password != results[0].password) {
                console.log("yeet2");
                    res.status(401).render(`layouts${"/login"}`, {
                        message: 'Incorrect Username or Password'
                    });
                    console.log("yeet3.5");
            } else {
                var id = results[0].username;
                var token = jwt.sign({ id }, process.env.JWT_SECRET, {
                    expiresIn: process.env.JWT_EXPIRES_IN
                });
                console.log("Token: " + token);

                var cookieOptions = {
                    expires: new Date(
                        Date.now() + process.env.JWT_COOKIE_EXPIRES * 24 * 60 * 60 * 1000
                    ),
                    httpOnly: true
                };
                res.cookie('jwt', token, cookieOptions);
                res.status(200).redirect(`layouts${"/"}`);
            }
        });
    } catch (error) {
        res.status(401).render(`layouts${"/login"}`, {
            message: 'Incorrect Username or Password'
        });
        console.log("yeet4");
    }
    res.status(401).render(`layouts${"/login"}`, {
        message: 'Incorrect Username or Password'
    });
    console.log("yeet5");
}