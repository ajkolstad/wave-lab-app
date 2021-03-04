import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'inheritable_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'models/user.dart';
import 'models/darkmode_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  runApp(new StateContainer(child: App(/*preferences: await SharedPreferences.getInstance()*/)));
}
