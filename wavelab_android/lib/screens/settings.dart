import 'package:flutter/material.dart';
import '../widgets/login.dart';
import '../widgets/change_darkmode.dart';

class Settings extends StatefulWidget {

  SettingsState createState() => SettingsState();

}

class SettingsState extends State<Settings> {

  String username = '';
  bool _darkmode;
  final curDarkmode = new darkmode();

  void initState() {
    super.initState();
    setState(() {
      curDarkmode.initDarkmode();
      _darkmode = curDarkmode.getDarkmode();
    });
    print("Darkmode: ${_darkmode}");
  }

  Widget build(BuildContext context){

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
                      Text('Settings', style: TextStyle(color: Colors.white, fontSize: 30)),
                    ]
                )
            ),
            Divider(
              color: Colors.white,
              thickness: 4,
              indent: 20,
              endIndent: 20,
            ),

            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .3, 0, MediaQuery.of(context).size.width * .3, 0),
                        shape: Border.all(color: Colors.white, width: 1.0),
                        child: Text('Login', style: TextStyle(color: Colors.white)),
                        onPressed: () {LoginPopup(context, username).then((onValue) {
                          username = onValue;
                        });},
                      )
                    ]
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .1, 20, MediaQuery.of(context).size.width * .08, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Darkmode', style: TextStyle(color: Colors.white)),
                    Switch(
                        value: _darkmode,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                        activeColor: Colors.lightBlue,
                        activeTrackColor: Colors.lightBlue[300],
                        onChanged: (bool state) {
                          setState(() {
                            _darkmode = state;
                            curDarkmode.darkmodeSwitch(state);
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
/*
  void pushLogin(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Login())
    );
  }*/
}