import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/db_calls.dart';
import '../models/user_data.dart';
import '../models/user.dart';
import '../inheritable_data.dart';

bool login(String username, String password){
  List<userData> userLoginData = [];
  dbCalls.loginUser(username, password).then((userData) {
    userLoginData = userData;
    if(userLoginData.length < 1)
      return false;
    else return true;
  });
}

LoginPopup(BuildContext context, String username, bool darkmode) {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool error = false;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkmode ? Colors.white : Colors.grey[400],
          title: Text("User Login"),
          content: Container(
            height: 100.0,
            child: Column(
            children: <Widget>[
              if(error)
                Text("The username or password was incorrect"),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: "Username")
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Password")
              )
            ]
          )),
            actions: <Widget>[
              MaterialButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.of(context).pop();
                }
              ),
              MaterialButton(
                  child: Text("Login"),
                  onPressed: (){
                    if(login(usernameController.toString(), passwordController.toString())) {
                      final dmodeContainer = StateContainer.of(context);
                      dmodeContainer.updateUser(usernameController.toString(), passwordController.toString());
                      Navigator.of(context).pop(
                          usernameController.text.toString());
                    }
                    else{
                      usernameController.clear();
                      passwordController.clear();
                      error = true;
                    }


                  }
              )
            ]
        );
      });
}