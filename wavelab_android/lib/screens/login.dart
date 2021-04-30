import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Login extends StatefulWidget{

  LoginState createState()=> LoginState();

}

class LoginState extends State<Login> {

  String username;
  String password;

  bool darkmode;


/*
  @override
  void initState() {
    super.initState();
    setState((){
      darkmode = widget.preferences.getBool('darkmode') ?? false;
    });
  }

  void darkmodeSwitch(bool value) async{
    setState(() {
      darkmode = value;
      widget.preferences.setBool('darkmode', darkmode);
    });
  }
*/
  Widget build(BuildContext context){
    return SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
            start: 5.0,
            top: 10.0,
            end: 5.0,
            bottom: 10.0
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              ),
              login_intro(),
              Username(),
              Password(),
              SignIn()
            ]
        )
    );
  }
  Widget login_intro(){
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Text('Please sign in', style: TextStyle(fontSize: 30, color: Colors.white))
                    )
                  ],
                )
              ],
            )
        )
    );
  }

  Widget Username(){
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              color:Colors.white,
              width: 280,
              height: 35,
              child: TextField(
                //autofocus: true,
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Username',),
                  keyboardType: TextInputType.text,
                  onChanged: (newVal) {
                    username = newVal;
                  }
                //controller: number,
              )
          )
        ],
      ),
    );
  }

  Widget Password(){
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: Colors.white,
              width: 280,
              height: 35,
              child: TextField(
                //autofocus: true,
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password',),
                  keyboardType: TextInputType.text,
                  onChanged: (newVal) {
                    password = newVal;
                  }
                //controller: number,
              )
          )
        ],
      ),
    );
  }

  Widget SignIn() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width * .65,
                height: 35,
                child: Container(
                    //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: FlatButton(
                      child: Text('Sign in'),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {loginAction(username, password);
                      },
                    )
                )
            )
          ]
    );
  }
}

void loginAction(username, password){
  print('username: $username, password: $password');
}