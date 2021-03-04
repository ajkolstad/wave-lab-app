import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Darkmode{
  bool darkmodeState;

  Darkmode(bool init) {
    this.darkmodeState = init;
  }

  /*Future initDarkmode() async {
    final preferences = await SharedPreferences.getInstance();
    darkmodeState = preferences.getBool('darkmode') ?? false;
    print("init darkmode: ${darkmodeState}");
  }

  bool getDarkmode() {
    print("return darkmode: ${darkmodeState}");
    return darkmodeState;
  }*/

  Future darkmodeSwitch(bool newValue) async {
    //darkmodeState = newValue;
    print("change darkmode: ${darkmodeState}");
      final preferences = await SharedPreferences.getInstance();
      preferences.setBool('darkmode', darkmodeState);
  }
}