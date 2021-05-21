/*********************************************************
 * This file controls the app by calling the screen controller materials
 * This is the main function of the app that wont be called again.
 ********************************************************/
import 'package:flutter/material.dart';
import 'screen_controller.dart';

class App extends StatelessWidget{

  // Set title and primary color and call the screen controller for the app
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