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

# How to access:
 - Site will be at localhost:3000
 - PHPMyadmin will be at localhost/phpmyadmin
    DWB : 0
    LWF : 1

---------------------------------------------------------
# Database Daemon
depth_sensor.py

- Description:   Accesses SQLite DB and transfers most recent depths to MySQL DB
- Dependencies:  None
- Software:      MySQL, SQLAlchemy, SQLite

```bash
python depth_sensor.py [Path]  [Log]  [Interval]
	- Path		the absolute path to the SQLite DB
	- Log		absolute path to output log file
	- Interval	seconds to wait before looping
```

valves.py

- Description:   Accesses MySQL DB to actuate valves
- Dependencies:  control.py, conf.py, adam.py
- Software:      MySQL

```bash
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

```bash
python test_valves.py
```
