import 'package:shared_preferences/shared_preferences.dart';

// Darkmode class that stores darkmode state
class Darkmode{
  bool darkmodeState;

  // Initialize the darkmode state
  Darkmode(bool init) {
    this.darkmodeState = init;
  }

  // Switch the darkmode state when the switch is pressed
  Future darkmodeSwitch(bool newValue) async {
    print("change darkmode: ${darkmodeState}");
      final preferences = await SharedPreferences.getInstance();
      preferences.setBool('darkmode', darkmodeState);
  }
}