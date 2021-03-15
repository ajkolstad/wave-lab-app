import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'inheritable_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'models/user.dart';
import 'models/darkmode_state.dart';

// Main function calling app
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Let the app on the phone work with both landscapes and right side up on the phone will work. Not upside down
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  runApp(new StateContainer(child: App(/*preferences: await SharedPreferences.getInstance()*/)));
}
