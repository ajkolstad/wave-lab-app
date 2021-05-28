# Database Daemon

## Requirements
- Python2
- MySQL
- SQLite

## Important Files

### `/hardware_ineraction/depth_sensor.py`

- Description:   Accesses SQLite DB and transfers most recent depths to MySQL DB
- Dependencies:  N/A
- Software:      MySQL, SQLAlchemy, SQLite

```
python depth_sensor.py [Path]  [Log]  [Interval]
	- Path		the absolute path to the SQLite DB [default: /a1/walve/data/levels.sqlite]
	- Log		absolute path to output log file
	- Interval	seconds to wait before looping
```

### `Output Format`
Log
- keeps track of time when DB is updated 

```
File exists: /a1/walve/data/levels.sqlite

Fri May 28 09:12:57 2021 - DWB updated
Fri May 28 09:12:59 2021 - LWF updated
Fri May 28 09:13:16 2021 - DWB updated
Fri May 28 09:13:18 2021 - LWF updated
```

### `/hardware_ineraction/valves.py`

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

### `Output Format`
Log
- Outputs the starting parameters and then logs the time and action taken to allow tracing of potential issues

```
Repeat interval:                15s
DWB Max:                        2.0m
LWF Max:                        4.2m
Min fill / 10 intervals:        0.25m

Fri May 28 09:17:50 2021 - [DWB] Starting...
Fri May 28 09:17:50 2021 - [LWF] Starting...
Fri May 28 09:18:20 2021 - [DWB] Not filling,   no target found
Fri May 28 09:18:21 2021 - [LWF] Filling
Fri May 28 09:18:50 2021 - [DWB] Filling
Fri May 28 09:18:51 2021 - [LWF] Fill finished, updating database
Fri May 28 09:19:21 2021 - [DWB] Filling
Fri May 28 09:19:21 2021 - [LWF] Not filling,   no target found
...

```

Error
- Notes a successful start and then logs the error detected as well as the time that it occured
- This it the main tool to seeing why the system stopped a fill early / or didn't actuate on a target fill

```
Successfully started

Fri May 22 09:19:21 2021 - [DWB] STAGNATION DETECTED!!! STOPPING FILL
Fri May 28 09:19:21 2021 - [LWF] INVALID TARGET DETECTED!!! CANNOT ACTUATE WATER VALVE 
```

### `/hardware_ineraction/test_valves.py`
- Description:   Tests valves.py for correct actuation of the vavles when appropriate, outputs results to command line
- Dependencies:  control.py, conf.py
- Software:      MySQL

```
python test_valves.py
```