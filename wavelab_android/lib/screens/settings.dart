import 'package:flutter/material.dart';
import '../widgets/login.dart';
import '../models/darkmode_state.dart';
import '../models/user.dart';
import '../models/user_data.dart';
import '../models/db_calls.dart';
import '../inheritable_data.dart';
class Settings extends StatefulWidget {

  SettingsState createState() => SettingsState();

}

class SettingsState extends State<Settings> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String username = '';
  Darkmode darkmodeClass;
  User user;
  bool newDarkmode;
  bool error = false;

  void updateDarkmode(bool _darkmode){
    final dmodeContainer = StateContainer.of(context);
    dmodeContainer.updateDarkmode(newDarkmode: _darkmode);
  }

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
        //color: Colors.grey[700],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Settings', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, fontSize: 30)),
                    ]
                )
            ),
            Divider(
              color: darkmodeClass.darkmodeState ? Colors.white : Colors.black,
              thickness: 4,
              indent: 20,
              endIndent: 20,
            ),

            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if(user.Name == "")
                        FlatButton(
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .3, 0, MediaQuery.of(context).size.width * .3, 0),
                          shape: Border.all(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black, width: 1.0),
                          child: Text('Login', style: TextStyle(color: darkmodeClass.darkmodeState ? Colors.white : Colors.black)),
                          onPressed: () {LoginPopup(username, darkmodeClass.darkmodeState);}
                        )
                      else
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
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
                                dmodeContainer.updateUser("", "");
                              },
                            )
                          ],
                        )
                    ]
                )
            ),
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
                            updateDarkmode(newDarkmode);
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

  void login(String username, String password, bool darkmode){
    List<userData> userLoginData = [];
    dbCalls.loginUser(username, password).then((userData) {
      userLoginData = userData;
      if(userLoginData.length < 1){
        setState(() {
          usernameController.clear();
          passwordController.clear();
          errorPopup(darkmode);
        });
      }

      else{
        final dmodeContainer = StateContainer.of(context);
        dmodeContainer.updateUser(userLoginData[0].Name, userLoginData[0].Username);
        usernameController.clear();
        passwordController.clear();
        Navigator.of(context).pop(usernameController.text);
      }
    });
  }

  void LoginPopup(String username, bool darkmode) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: darkmode ? Colors.white : Colors.grey[400],
              title: Text("User Login"),
              content: Container(
                  height: 100.0,
                  child: Column(
                      children: <Widget>[
                        if(error)
                          Text("The username or password was incorrect"),
                        TextField(
                            controller: usernameController,
                            decoration: InputDecoration(hintText: "Username")
                        ),
                        TextField(
                            controller: passwordController,
                            decoration: InputDecoration(hintText: "Password")
                        )
                      ]
                  )),
              actions: <Widget>[
                MaterialButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
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