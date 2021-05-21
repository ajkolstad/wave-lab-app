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
	- Path		the absolute path to the SQLite DB
	- Log		absolute path to output log file
	- Interval	seconds to wait before looping
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
 
 ### `/hardware_ineraction/test_valves.py`
- Description:   Tests valve.py for correct actuation of the vavles when appropriate
- Dependencies:  control.py, conf.py
- Software:      MySQL

```
python test_valves.py
```
---------------------------------------------------------

# Android App

## Requirements
 - Dart
 - Flutter
 - AndroidStudio
 - XAMPP
 - Completion of Database setup

## How to use locally with an emulator
1. Install XAMPP
   - Start Apache and MySQL servers on XAMPP.
2. To add the SQL commands to the local database:
   - Enter the xampp/htdocs folder. 
   - Create a new folder /WavelabDB.
   - add get.depth.php from /wave-lab-app/wavelab_android/lib/database and add it to xampp/htdocs/WavelabDB.
3. To connect the app to the database:
   - Enter /wave-lab-app/wavelab_android/lib/models and the ROOT variable will be what is changed.
   - Run ipconfig in the command prompt to find the **Link-local IPv6 Address**.
   - Copy this address into the ROOT variable replacing "192.168.1.19" or a similar address in the string.
4. Install Android Studio onto the computer: [Android Studio Download](https://developer.android.com/studio/?gclid=Cj0KCQjwkZiFBhD9ARIsAGxFX8DBMKeY751Vh5YeSbLYcRa_O5EmqeZwIKhWKGAtFi8KNTQhs4vDc4IaAoeNEALw_wcB&gclsrc=aw.ds).
5. Install Flutter and Dart onto the computer: [Download](https://flutter.dev/docs/get-started/install/windows).
6. Follow these steps to create an emulator on the computer: [Emulator Steps](https://developer.android.com/studio/run/managing-avds).
7. Choose an emulator by clicking on **AVD Manager** in Android Studio to enter Your Virtual Devices page and pressing the green button to start the emulator up.
8. To run go back to the original Android Studio Page and click the green arrow to launch the app on the Android emulator. 

## How to download on Android phone
- Before trying to download the app onto the android phone, Android Studio must be installed onto the computer: [Android Studio Download](https://developer.android.com/studio/?gclid=Cj0KCQjwkZiFBhD9ARIsAGxFX8DBMKeY751Vh5YeSbLYcRa_O5EmqeZwIKhWKGAtFi8KNTQhs4vDc4IaAoeNEALw_wcB&gclsrc=aw.ds).

- Connect the Android phone to the computer with a USB cable.
   - If the computer uses Windows, a USB Driver needs to be installed to communicate with the phone. 
   - Here is the link for the USB Driver connecting to Android: [Android Connector](https://developer.samsung.com/mobile/android-usb-driver.html).
- For Windows 10:
  1. Make sure the Android phone is connected to the computer.
  2. From Windows Explorer, open **Computer Management**.
  3. In the **Computer Management** left pane, select **Device Manager**. 
  4. In the **Device Manager** right pane, locate and expand **Portable Devices** or **Other Devices**, depending on which one you see.
  5. Right-click the name of the device you connected, and then select Update Driver Software.
  6. In the **Hardware Update wizard**, select **Browse my computer for driver software** and click **Next**.
  7. Click **Browse** and then locate the USB driver folder. For example, the Google USB Driver is located in android_sdk\extras\google\usb_driver\.
  9. Click **Next** to install the driver.
- For earlier Windows versions follow the steps [here](https://developer.android.com/studio/run/oem-usb)
- To put the Android phone in developer mode(needed for this app):
  1. Open the **Settings** app on your Android phone.
     1.a If the Android phone is a model v8.0 or high select System. Otherwise, proceed to the next step.
  2. Scroll to the bottom and select **About phone**.
  3. Scroll to the bottom and tap **Build number** seven times.
     3.a If **Build number** isn’t here click on **Software Information** and **Build number** should be there.
  5. Return to the previous screen, scroll to the bottom, and tap **Developer options**.
  6. In the **Developer options** window, scroll down to find and enable **USB debugging**.
- Now in AndroidStudio:
  1. Select the WaveLab app file.
  2. Click run/run from the toolbar.
  3. Select **Choose a running device** and select the Android phone connected.
  4. Click the **Ok** button.

## Important Files

### `/wavelab_android/lib/database/get_depth.php`
 - Where the connection to the database is.
 - Holds all of the SQL querys for the android app.

### `/wavelab_android/lib/models/db_calls.dart`
 - Encodes all of the data before sending it to /wavelab_android/lib/database/get_depth.php.
 - Decodes the json data from SQL response into a list of strings.

### `/wavelab_android/lib/screen_controller.dart`
 - Controls the tab movement in the app.
 - Formats the header and tab bar at the bottom of each screen.

### `/wavelab_android/lib/screens`
 - Holds each screen file: home.dart, directional_wave_basin.dart, large_wave_flume.dart, and settings.dart.
 - Prints the body of each tab but the screen_controller.dart controlls which tab is printed at a time.
---------------------------------------------------------

# iOS App - Unfinished

## Requirements
 - A Mac with Xcode installed

## How to build
1. Clone repository
2. Open `/Apple Apps/` in Xcode
3. Either plug in phone and prepare for development or use emulator
4. Click the build button to build
5. App will either be installed on target iPhone or emulator will start
