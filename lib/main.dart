import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hitpay/CreateUserScreen.dart';
import 'package:hitpay/Homepage.dart';
import 'package:hitpay/LocalDirectory.dart';
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
  String _passcode;
  final storage = new FlutterSecureStorage();
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  void initState() {
    //DBHelper.db.DropTable();
    DBHelper.db.initDB();
    DBHelper.db.getPathDB().then((String val){
      print(val);
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
    if (_passcode==null) {
      //print("passcode null");
      ReadPasscode().then((x) {
        setState(() {
          _passcode = x;
        });
      });
    }
    if (title=="") title=(_passcode == ""?"Create passcode":"Type passcode");
    return Builder(builder: (BuildContext context)=> Scaffold(
      body: PasscodeScreen(
        title: Text(title,style: TextStyle(color: Colors.white)),
        shouldTriggerVerification: _verificationNotifier.stream,
        deleteButton: Icon(Icons.backspace,color: Colors.white,),
        passwordEnteredCallback: (String value){
          if (_passcode == "")
          {
            SavePasscode(value);
            _passcode = value;
            Navigator.of(context).pop();
            Navigator.push(context, new MaterialPageRoute(builder: (context)=> new CreateUserScreen()));
          }
          else if (_passcode==value)
          {
            Navigator.of(context).pop();
            Navigator.push(context, new MaterialPageRoute(builder: (context)=> new Homepage()));
          }
          setState(() {
            title="Incorrect! Re-type passcode";
          });
        },
      ),
    ),);
  }

  Future ReadPasscode() async
  {
//    print("Read passcode start");
//    print("Read passcode start");
//    print("Read passcode start");
    _passcode = await storage.read(key: "passcode_hitpay");
    if (_passcode == null) _passcode ="";

//    print("Read passcode end "+_passcode);
    return _passcode;
  }
  
  Future SavePasscode(String passcode) async{
    await storage.write(key: 'passcode_hitpay', value: passcode);
    return passcode;
  }
}
