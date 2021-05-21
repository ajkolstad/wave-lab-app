/************************************************************
 * This file controls what the inheritable data stores. The data stored here
 * are the darkmode status and the user information if they are signed in.
 * Inheritable data is data that can be accessed by any screen at any time.
 * This is good when data can't be passed as an agruement when calling a screen.
 ***********************************************************/
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/darkmode_state.dart';
import 'models/user.dart';

// Inheritable widget that stores the statewidget data
class InheritableData extends InheritedWidget {

  final StateContainerState state;

  InheritableData({this.state, Widget myChild})
      : super(child: myChild);

  // The statewidget in the inheritable widget is changed automatically if the inheritable widget is called
  bool updateShouldNotify(InheritableData oldWidget) => true;
      //oldWidget.state.darkmode != state.darkmode;
}

// Holds the state of the inheritable data
class StateContainer extends StatefulWidget{
  final Widget child;
  final Darkmode darkmode;
  User user;

  StateContainer({this.child, this.darkmode, this.user});

  static StateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritableData>()/*inheritFromWidgetOfExactType(InheritableData)*/ as InheritableData).state;
  }

  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer>{

  Darkmode darkmode;
  User user;
  bool initDarkmode;

  // Initializes statecontainer for the app
  void initState(){
    super.initState();
    getDarkmode();
    initUser();
  }

  // Initializes the user class object to empty
  void initUser() {
    setState(() {
      user = new User("", "");
    });
  }

  // Initializes the darkmode class object to what the sharedPreferences of the app holds
  void getDarkmode() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      initDarkmode = preferences.getBool('darkmode') ?? true; // If there is no saved data in the phone set darkmode to true
      darkmode = new Darkmode(initDarkmode);
    });
  }

  // Updates the user class object
  void updateUser(newName, newUser){
    setState(() {
      user.Name = newName;
      user.Username = newUser;
    });
  }

  // Updates the darkmode class object
  void updateDarkmode({newDarkmode}){
    setState(() {
      darkmode.darkmodeState = newDarkmode;
    });
  }

  // Builds inheritable data with the initialized state
  Widget build(BuildContext context){
    return InheritableData(
      state: this,
      myChild: widget.child
    );
  }
}