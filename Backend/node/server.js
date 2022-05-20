const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const https = require('https');
const http = require("http").createServer(app);
const mysql = require("mysql");
const path = require("path");
const sha256 = require("sha256");
const cookieParser = require('cookie-parser');
app.use(cookieParser());

app.set('view engine', 'ejs');


const { request } = require("http");
const { response, query } = require("express");



app.use(express.urlencoded({
    extended: true
}));


app.use(function (request, result, next) {
    result.setHeader("Access-Control-Allow-Origin", "*");
    next();
});


const connection = mysql.createConnection({
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "aiessa",
    multipleStatements: true
});


connection.connect(function (error) {
    console.log("mysql error:" + error);
});




// -----------------------------------------------client side-------------------------------
app.get("/", (request, response) => {
    response.end("hai");
});

// user login
app.post("/validate", (request, response) => {
    console.log("Validate", request.body);
    connection.query("Select id from users where mail = ? and password = sha2(?,256)", [request.body.mail, request.body.password], function (error, result) {
        if (error == null && result.length == 1) {
            console.log("validate");
            response.send("done");
            response.end();
        }
        else {
            console.log("validate error");
            response.end("error");
        }
        console.log("validate mysql error: ", error);
    });
});

// user registration
app.post("/register", (request, response) => {
    console.log("Register", request.body);
    connection.query("Insert into users(username,mail,companionName,companionMail,password,deaf,mute,blind,other) Values(?,?,?,?,sha2(?,256),?,?,?,?)", [request.body.username, request.body.mail, request.body.companionName, request.body.companionMail, request.body.password, request.body.deaf, request.body.mute, request.body.blind, request.body.other], function (error, result) {
        if (error == null) {
            console.log("Register");
            response.send("done");
            response.end();
        }
        else {
            console.log("Register error");
            response.end(JSON.stringify({ "status": "error" }));
        }
        console.log("Register mysql error: ", error);
    });
});

// user voice assign
app.post("/getUserLabels", (request, response) => {
    console.log("get User Labels", request.body);
    connection.query("Select label from audio where userId = (Select id from users where mail = ?) group by label", [request.body.mail], function (error, result) {
        if (error == null) {
            console.log("get User Labels");
            response.send(JSON.stringify(result));
            response.end();
        }
        else {
            console.log("get User Labels error");
            response.end("error");
        }
        console.log("get User Labels mysql error: ", error);
    });
});

// --------------------------------client side ends----------------------------------------------------



// -----------------------------------admin Side starts-------------------------------------------------


// admin login
app.post("/adminValidate", (request, response) => {
    console.log("admin login", request.body);
    if (request.body.mail == "admin@gmail.com" && request.body.password == "admin@123") {
        response.cookie('status', "lsjfklsdkflsdkfldksf'", { maxAge: Date.now() + 900000, httpOnly: true });
        response.end("done");
    }
    else {
        response.end("error");
    }
});


// dashboard home info
app.get("/homeInfo", (request, response) => {
    console.log("analytics home", request.body);
    connection.query("Select (Select count(id) from users) as totalUsers,(Select count(id) from signProcessing) as totalProcessed;Select (Select count(id) from users where deaf='yes' and mute='no' and blind='no' and other='no') as Deaf,\
                    (Select count(id) from users where mute='yes' and deaf='no' and blind='no' and other='no') as Mute, (Select count(id) from users where blind='yes' \
                    and mute='no' and deaf='no' and other='no') as Blind, (Select count(id) from users where other='yes' and mute='no' and blind='no' and deaf='no') as \
                    Other, (Select count(id) from users where mute='yes' and blind='yes' and deaf='no') as 'Mute and Blind', (Select count(id) from users where mute='yes' and \
                    blind='no' and deaf='mute') as 'Mute and Deaf', (Select count(id) from users where mute='no' and blind='yes' and deaf='yes') as 'Blind and Deaf' \
                    , (Select count(id) from users where mute='yer' and blind='yes' and deaf='yes') as 'Mute, Blind and Deaf';\
                    Select (Select count(id) from users where t1.date>=joinDate) as users, (Select count(id) from signProcessing where t1.date=cast(dateTime as DATE)) as processing, \
                    DATE_FORMAT(t1.date,'%d/%m/%Y') as date from (select selected_date as 'date' from\ (select adddate((Select min(joinDate) from users), t4.i * 10000 + t3.i * 1000 + t2.i * 100 + t1.i * 10 + t0.i) selected_date from\
                    (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,\
                    (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,\
                    (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,\
                    (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,\
                    (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v\
                                where selected_date <= CURDATE()) t1; ", function (error, result) {
        if (error == null) {
            console.log("analytics home");
            response.send(JSON.stringify(result));
            response.end();
        }
        else {
            console.log("analytocs home error");
            response.end(JSON.stringify({ "status": "error" }));
        }
        console.log("Register mysql error: ", error);
    });
});

// user info
app.get("/usersInfo", (request, response) => {
    console.log("User Info", request.body);
    connection.query("Select sha2(id,256) as id,username,mail,deaf,mute,blind,other,DATE_FORMAT(joinDate,'%d/%m/%Y') as joinDate from users", function (error, result) {
        if (error == null) {
            console.log("User Info home");
            response.send(JSON.stringify(result));
            response.end();
        }
        else {
            console.log("User Info home error");
            response.end("error");
        }
        console.log("User Info mysql error: ", error);
    });
});

// dashboard
app.get('/dashboard', function (request, response) {
    if (request.cookies["status"] == "lsjfklsdkflsdkfldksf'")
        response.sendFile(__dirname + '/templates/dashboardHome.html');
    else
        response.redirect("/login");
});

// user info page
app.get('/users', function (request, response) {
    if (request.cookies["status"] == "lsjfklsdkflsdkfldksf'")
        response.sendFile(__dirname + '/templates/dashboardUsers.html');
    else
        response.redirect("/login");
});

// login page
app.get('/login', function (request, response) {
    response.sendFile(__dirname + '/templates/login.html');
});

//--------------------------- admin Side ends---------------------------------------



// start the server
http.listen(3000, "0.0.0.0", function () {
    console.log("Listening on*:3000");
});