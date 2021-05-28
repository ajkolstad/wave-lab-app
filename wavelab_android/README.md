# Android for the Wave Lab

An Android app for the Hinsdale Wave Lab.

## Important Files

### `/lib/database/get_depth.php`
 - Where the connection to the database is.
 - Holds all of the SQL querys for the android app.

### `/lib/models/db_calls.dart`
 - Encodes all of the data before sending it to /wavelab_android/lib/database/get_depth.php.
 - Decodes the json data from SQL response into a list of strings.

### `/lib/screen_controller.dart`
 - Controls the tab movement in the app.
 - Formats the header and tab bar at the bottom of each screen.

### `/lib/screens/directional_wave_basin.dart`
 - Grabs the correct depth and target depth data to be displayed for the user.
 - If the user is signed in, an add target depth, start filling(without target depth), and stop filling options will appear to the user.

### `/lib/screens/home.dart`
 - Grabs the correct depth and target depth data for both the LWF and DWB to be displayed for the user.
 - Displays live views of both the LWF and DWB from different angles.

### `/lib/screens/large_wave_flume.dart`
 - Grabs the correct depth and target depth data to be displayed for the user.
 - If the user is signed in, an add target depth, start filling(without target depth), and stop filling options will appear to the user.

### `/lib/screens/settings.dart`
 - Allows the user to login if and will display who is logged in if they sign in successfully
 - Provides a button to switch from darkmode and lightmode in the app

### `/lib/widgets/play_youtube.dart`
 - Controls how the youtube live views will be displayed.
