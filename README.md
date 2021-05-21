# App to Control the Water Level at the Hinsdale Wave Research Lab

## Components
 - Database
 - Website
 - Database Daemon
 - Android App
# Database

## Requirements
 - XAMPP or equivalent MySQL server

## How to build
1. Install XAMPP
2. Run XAMPP and run Apache and MySQL
3. Go to localhost/phpmyadmin in browser
4. Make a new database called `wave_lab_database`
5. Run MySQL code within wave_lab_database.sql
6. Create a user and add to `user` table
   - Must be done within PHPMyAdmin
   - Needs `Username`, `Password`, and `Name`
7. Database is now ready for use
     - DWB : 0 | LWF : 1
---------------------------------------------------------
# Website

## Requirements
 - Javascript
 - NodeJS
 - Completion of Database setup

## How to build
1. Install NodeJS
2. Clone repository
3. Inside the repository, run `npm install` to download dependencies
4. Open `Website` directory
5. Run `node server.js`
6. Website is now live at localhost:port
   - Port is printed when server starts

## Important Files

### `/server.js`
 - Heart of the server and opens the port and launches the web server
 - Calls on helper functions to render website

### `/routes/auth.js`
 - Routes functions to buttons on webpage
 - Used for login and adding depth requests

### `/routes/pages.js`
 - Handles all webpage rendering
 - Connects to database to get information before rendering pages
 - Changes available page content if user is logged in

### `/controllers/auth.js`
 - Contains functions for logging in and posting depth requests

---------------------------------------------------------
# Database Daemon
depth_sensor.py

- Description:   Accesses SQLite DB and transfers most recent depths to MySQL DB
- Dependencies:  None
- Software:      MySQL, SQLAlchemy, SQLite

```
python depth_sensor.py [Path]  [Log]  [Interval]
	- Path		the absolute path to the SQLite DB
	- Log		absolute path to output log file
	- Interval	seconds to wait before looping
```

valves.py

- Description:   Accesses MySQL DB to actuate valves
- Dependencies:  control.py, conf.py, adam.py
- Software:      MySQL

```
python valves.py [Interval]  [DWB]  [LWF]  [Stag]  [Log]  [Error]
	- Interval 		seconds to wait before looping
	- DWB			directional wave basin max fill level (cm)
	- LWF			large wave flume max fill level (cm)
	- Stag			min fill amount / 10 intervals
	- Log			absolute path to output log file
	- Error		        absolute path to error log file
 ```
 
 test_valves.py
- Description:   Tests valve.py for correct actuation of the vavles when appropriate
- Dependencies:  control.py, conf.py
- Software:      MySQL

```
python test_valves.py
```
---------------------------------------------------------

# How to start:
 - pull files
 - Install XAMPP, launch Apache and MySQL
 - Install python3 (sudo apt install python3.6)
 - Install pip (sudo apt install python3-pip)
      use pip to install mysql-connector-python (pip3 install mysql-connector-python)

 - open terminal and type "cd Website", then "node server.js"
 - Also do "npm install" to get the additional packages
 - go to localhost/phpmyadmin, make a new database and import the databaseSetp.sql
 - You may have to add each table by themselves, with the User table being added last
 - Make your own user
--------------------------------------------------------