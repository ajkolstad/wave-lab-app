import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


LoginPopup(BuildContext context, String username) {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("User Login"),
          content: Container(
            height: 100.0,
            child: Column(
            children: <Widget>[
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
                    Navigator.of(context).pop(usernameController.text.toString());
                  }
              )
            ]
        );
      });
}