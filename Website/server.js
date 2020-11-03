var path = require('path');
var express = require('express');
var port = process.env.PORT || 3000;
var exphbs = require('express-handlebars');

var app = express();

app.engine('handlebars', exphbs({ defaultLayout: 'main' }));
app.set('view engine', 'handlebars');


app.use(express.static('public'));

app.listen(port, function () {
  console.log("== Server listening on port ", port);
});

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