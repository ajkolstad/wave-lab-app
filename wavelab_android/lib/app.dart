import 'package:flutter/material.dart';
import 'screens/home.dart';

class App extends StatelessWidget{

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wavelab_Android',
      theme: ThemeData(primaryColor: Colors.blue),
      home: Home()
    );
  }
}