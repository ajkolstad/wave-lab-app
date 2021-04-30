import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen_controller.dart';

class App extends StatelessWidget{

  //final SharedPreferences preferences;

  //App({this.preferences});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wavelab_Android',
      theme: ThemeData(primaryColor: Colors.blue),
      home: ScreenController()
    );
  }
}