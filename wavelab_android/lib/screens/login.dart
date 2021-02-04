import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/header.dart';
import '../widgets/app_drawer.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Login extends StatefulWidget{

  LoginState createState()=> LoginState();

}

class ProfileScreen extends StatelessWidget {

  final String username;

  const ProfileScreen({Key key, @required this.username}) : super(key: key);

  logout(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Profile Screen'),
                automaticallyImplyLeading: false),
            body: Center(
                child: Column(children: <Widget>[
                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: Text('Username = ' + '\n' + username,
                          style: TextStyle(fontSize: 20))
                  ),
                  RaisedButton(
                    onPressed: () {
                      logout(context);
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text('Click Here To Logout'),
                  ),

                ],)
            )
        )
    );
  }

}

class LoginState extends State<Login> {

  String username;
  String password;

  bool darkmode;

  bool visible = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future userLogin() async {
    setState(() {
      visible = true;
    });

    username = usernameController.text;
    password = passwordController.text;

    var url = 'localhost:3000/login_user.php';
    var data = {'username': username, 'password' : password};
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

    if(message == 'Login Matched')
    {

      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(username : usernameController.text))
      );
    }else{

      // If Email or Password did not match.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );}
  }

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
    return AppHeader(
      header_title: 'Login',
      body: lwf_body(),
    );
  }

  Widget lwf_body() {
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
                  controller: usernameController,
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
                  controller: passwordController,
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