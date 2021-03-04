import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/darkmode_state.dart';
import 'models/user.dart';
import 'package:collection/collection.dart';

class InheritableData extends InheritedWidget {

  final StateContainerState state;

  InheritableData({this.state, Widget myChild})
      : super(child: myChild);

  bool updateShouldNotify(InheritableData oldWidget) => true;
      //oldWidget.state.darkmode != state.darkmode;
}

class StateContainer extends StatefulWidget{
  final Widget child;
  final Darkmode darkmode;
  User user;

  StateContainer({this.child, this.darkmode, this.user});

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritableData) as InheritableData).state;
  }

  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer>{

  Darkmode darkmode;
  User user;
  bool initDarkmode;

  void initState(){
    super.initState();
    getDarkmode();
    initUser();
  }

  void initUser() {
    setState(() {
      user = new User("", "");
    });
  }

  void getDarkmode() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      initDarkmode = preferences.getBool('darkmode') ?? false;
      darkmode = new Darkmode(initDarkmode);
    });

  }

  void updateUser(newName, newUser){
    setState(() {
      user.Name = newName;
      user.Username = newUser;
    });
  }

  void updateDarkmode({newDarkmode}){
    setState(() {
      darkmode.darkmodeState = newDarkmode;
    });
  }

  Widget build(BuildContext context){
    //getDarkmode();
    //initUser();
    return InheritableData(
      state: this,
      myChild: widget.child
    );
  }
}