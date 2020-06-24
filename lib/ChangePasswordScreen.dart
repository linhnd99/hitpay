import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hitpay/Models/Password.dart';
import 'package:hitpay/Utils/DBHelper.dart';
import 'package:passcode_screen/passcode_screen.dart';

class ChangePasswordScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePasswordScreenState();
  }
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  Password _passcode;
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  final storage = new FlutterSecureStorage();
  String text1="Type old password";


  @override
  Widget build(BuildContext context) {
    DBHelper.db.getPassword().then((value){
      _passcode = new Password();
      _passcode.password = value;
      _passcode.id = 1;
    });

    return Scaffold(
      body: PasscodeScreen(
        title: Text(text1,style: TextStyle(color: Colors.white),),
        deleteButton: Icon(Icons.backspace, color: Colors.white,),
        cancelButton: Icon(Icons.cancel,color: Colors.white,),
        shouldTriggerVerification: _verificationNotifier.stream,
        cancelCallback: (){
          Navigator.of(context).pop();
        },
        passwordEnteredCallback: (String value){
          if (value==_passcode.password) {
            Navigator.of(context).pop();
            Navigator.push(context, new MaterialPageRoute(builder: (context)=> new ChangePasswordScreen2()));
          }
          else {
            setState(() {
              text1 = "Incorrect! Re-type old password";
              _verificationNotifier.add(false);
            });
          }
        },
      ),
    );
  }

}

class ChangePasswordScreen2 extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePasswordScreen2State();
  }
}

class ChangePasswordScreen2State extends State<ChangePasswordScreen2>{
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  final storage = new FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PasscodeScreen(
        title: Text("Type new password",style: TextStyle(color: Colors.white),),
        deleteButton: Icon(Icons.backspace, color: Colors.white,),
        cancelButton: Icon(Icons.cancel,color: Colors.white,),
        cancelCallback: (){
          Navigator.of(context).pop();
        },
        shouldTriggerVerification: _verificationNotifier.stream,
        passwordEnteredCallback: (String value){
          Navigator.pop(context);
          Password pass = new Password();
          pass.id = 1;
          pass.password = value;
          Navigator.push(context, new MaterialPageRoute(builder: (context)=>new ChangePasswordScreen3(passcode: pass)));
        },
      ),
    );
  }

}

class ChangePasswordScreen3 extends StatefulWidget {

  Password passcode;

  ChangePasswordScreen3({Key key, this.passcode});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePasswordScreen3State(newPassword: passcode);
  }
}

class ChangePasswordScreen3State extends State<ChangePasswordScreen3> {

  Password newPassword;

  ChangePasswordScreen3State({Key key, @required this.newPassword});

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PasscodeScreen(
        title: Text("Re-type new password",style: TextStyle(color: Colors.white),),
        deleteButton: Icon(Icons.backspace, color: Colors.white,),
        cancelButton: Icon(Icons.cancel, color: Colors.white,),
        cancelCallback: (){
          Navigator.of(context).pop();
        },
        shouldTriggerVerification: _verificationNotifier.stream,
        passwordEnteredCallback: (String value){
          if (value==newPassword.password) {
            DBHelper.db.UpdatePassword(newPassword).then((onValue){
              showDialog(context: context, builder: (context)=> AlertDialog(
                content: Text("Change password successfully"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
            });
          }
          else {
            showDialog(context: context, builder: (context)=> AlertDialog(
              content: Text("Change password failled"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
          }
        },
      ),
    );
  }
}