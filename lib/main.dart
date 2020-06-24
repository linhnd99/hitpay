import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hitpay/CreateUserScreen.dart';
import 'package:hitpay/Homepage.dart';
import 'package:hitpay/LocalDirectory.dart';
import 'package:hitpay/Models/Password.dart';
import 'package:hitpay/Utils/DBHelper.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(LockScreen());

class LockScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LockScreenState();
  }
}

class LockScreenState extends State<LockScreen>{
  Password _passcode;
  final storage = new FlutterSecureStorage();
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  void initState() {
    //DBHelper.db.DropTable();
    _passcode = new Password();
    DBHelper.db.initDB();
    DBHelper.db.getPathDB().then((String val){
      print(val);
    });
    DBHelper.db.getPassword().then((password){
      _passcode.password = password;
      _passcode.id = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: lock(),
    );
  }

  String title = "";
  Widget lock() {
    if (title=="") title=(_passcode.password == ""?"Create passcode":"Type passcode");
    return Builder(builder: (BuildContext context)=> Scaffold(
      body: PasscodeScreen(
        title: Text(title,style: TextStyle(color: Colors.white)),
        shouldTriggerVerification: _verificationNotifier.stream,
        deleteButton: Icon(Icons.backspace,color: Colors.white,),
        passwordEnteredCallback: (String value){
          if (_passcode.password == "")
          {
            _passcode.password = value;
            _passcode.id = 1;
            DBHelper.db.InsertPassword(_passcode);

            Navigator.of(context).pop();
            Navigator.push(context, new MaterialPageRoute(builder: (context)=> new CreateUserScreen()));
          }
          else if (_passcode.password==value)
          {
            Navigator.of(context).pop();
            Navigator.push(context, new MaterialPageRoute(builder: (context)=> new Homepage()));
          }
          else {
            setState(() {
              title="Incorrect! Re-type passcode";
            });
            _verificationNotifier.add(false);
          }
        },

      ),
    ),);
  }


}
