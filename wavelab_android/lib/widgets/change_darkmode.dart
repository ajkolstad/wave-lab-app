import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class darkmode{
  bool _darkmode;

  Future initDarkmode() async {
    final preferences = await SharedPreferences.getInstance();
    _darkmode = preferences.getBool('darkmode') ?? false;
    print("init darkmode: ${_darkmode}");
  }

  bool getDarkmode() {
    print("return darkmode: ${_darkmode}");
    return _darkmode;
  }

  Future darkmodeSwitch(bool newValue) async {
    _darkmode = newValue;
    print("change darkmode: ${_darkmode}");
      final preferences = await SharedPreferences.getInstance();
      preferences.setBool('darkmode', _darkmode);
  }
}