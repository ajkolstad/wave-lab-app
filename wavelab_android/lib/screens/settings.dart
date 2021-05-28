/************************************************************
 * This file controls the settings screen of the app. The main functions are
 * loging in a user and changing the darkmode state. If the user logs in a
 * popup will appear for them to enter their username and password. The
 * darkmode state is saved on the phone so the next time the user enters the
 * app the darkmode state will be the same.
 ***********************************************************/
import 'package:flutter/material.dart';
import '../models/darkmode_state.dart';
import '../models/user.dart';
import '../models/user_data.dart';
import '../models/db_calls.dart';
import '../inheritable_data.dart';

// Setting widget that shows login button and darkmode switch
class Settings extends StatefulWidget {

  SettingsState createState() => SettingsState();

}

// The state of the setting widget
class SettingsState extends State<Settings> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String username = '';
  Darkmode darkmodeClass;
  User user;
  bool newDarkmode;

  // Updates the inheritable widget to change darkmode data
  void updateDarkmode(bool _darkmode){
    final dmodeContainer = StateContainer.of(context);
    dmodeContainer.updateDarkmode(newDarkmode: _darkmode);
  }

  // Initializes darkmode from inheritable widget
  void initAppState(){
    setState(() {
      final dmodeContainer = StateContainer.of(context);
      darkmodeClass = dmodeContainer.darkmode;
      user = dmodeContainer.user;
    });
  }

  Widget build(BuildContext context){

    initAppState();

    return Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Title of settings page
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Settings', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 30)),
                    ]
                )
            ),
            // Sets bar across screen below title
            Divider(
              color: darkmodeClass.darkmodeState ? Colors.white : Colors.black,
              thickness: 4,
              indent: 20,
              endIndent: 20,
            ),

            // Login/Logout button
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // If there is no user signed in show the login button
                      if(user.Name == "")
                        FlatButton(
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .3, 0, MediaQuery.of(context).size.width * .3, 0),
                          shape: Border.all(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, width: 1.0),
                          child: Text('Login', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black)),
                          onPressed: () {LoginPopup(username, darkmodeClass.darkmodeState);}
                        )
                        // If there is a user signed in, show the users name that is signed in and a logout button
                      else
                        Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text("Logged in:", style: TextStyle(fontSize: 20, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: Text("${user.Name}", style: TextStyle(fontSize: 25, color: darkmodeClass.darkmodeState ? Colors.white : Colors.black))
                            ),
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .3, 0, MediaQuery.of(context).size.width * .3, 0),
                              shape: Border.all(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, width: 1.0),
                              child: Text('Logout', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black)),
                              onPressed: () {
                                final dmodeContainer = StateContainer.of(context);
                                dmodeContainer.updateUser("", ""); // Sets user to empty if logout is pressed
                              },
                            )
                          ],
                        )
                    ]
                )
            ),
            // Darkmode switch
            Container(
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .1, 20, MediaQuery.of(context).size.width * .08, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Darkmode', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black)),
                    Switch(
                        value: darkmodeClass.darkmodeState,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                        activeColor: Colors.lightBlue,
                        activeTrackColor: Colors.lightBlue[300],
                        onChanged: (bool state) {
                          setState(() {
                            newDarkmode = state;
                            darkmodeClass.darkmodeSwitch(newDarkmode);
                            updateDarkmode(newDarkmode); // Update darkmode when switch is pressed
                          });
                        }
                        )
                  ],
                )
            )
          ],
        )
    );
  }

  // Popup error if login information isnt in database
  void errorPopup(bool darkmode){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkmode ? Colors.white : Colors.grey[400],
          title: Text("Username or Password was entered incorrectly"),
          actions:[
            MaterialButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
          ]
        );
      }
    );
  }

  // Check login data
  void login(String username, String password, bool darkmode){
    List<userData> userLoginData = [];
    dbCalls.loginUser(username, password).then((userData) {
      userLoginData = userData;
      // Clear data in username and password if the text boxes arent empty when the user data doesn't match database
      if(userLoginData.length < 1){
        setState(() {
          usernameController.clear();
          passwordController.clear();
          errorPopup(darkmode);
        });
      }
      // Login user and clear text boxes if user data matches database information
      else{
        final dmodeContainer = StateContainer.of(context);
        dmodeContainer.updateUser(userLoginData[0].Name, userLoginData[0].Username);
        usernameController.clear();
        passwordController.clear();
        Navigator.of(context).pop(usernameController.text);
      }
    });
  }

  // Login popup for user to input username and password
  void LoginPopup(String username, bool darkmode) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: darkmode ? Colors.white : Colors.grey[400],
              title: Text("User Login"), // Title of popup
              content: Container(
                  height: 100.0,
                  child: Column(
                      children: <Widget>[
                        // Text box for username
                        TextField(
                            controller: usernameController,
                            decoration: InputDecoration(hintText: "Username")
                        ),
                        // Text box for password
                        TextField(
                          obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(hintText: "Password")
                        )
                      ]
                  )),
              actions: <Widget>[
                // Cancel button
                MaterialButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
                // Login button
                MaterialButton(
                    child: Text("Login"),
                    onPressed: () {
                      print("username: ${usernameController.text}");
                      print("password: ${passwordController.text}");
                      login(usernameController.text, passwordController.text, darkmode);
                    }
                )
              ]
          );
        });
  }
}