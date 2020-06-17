import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Common/SharedData.dart';
import 'package:hitpay/Homepage.dart';
import 'package:hitpay/Utils/DBHelper.dart';

import 'Models/User.dart';

class CreateUserScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateUserScreenState();
  }
}

class CreateUserScreenState extends State<CreateUserScreen>{
  User user;
  TextEditingController txtName;
  TextEditingController txtAge;
  TextEditingController txtWalletValue;
  String error;


  @override
  void initState() {
    user = new User();
    txtName = new TextEditingController();
    txtAge = new TextEditingController();
    txtWalletValue = new TextEditingController();
    error="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Hitpay"),
        leading: Text(""),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left:20,right:20),
            child: Column(
              children: <Widget>[
                TextField(decoration: InputDecoration(labelText: 'Name'),
                  controller: txtName,
                ),
                TextField(decoration: InputDecoration(labelText: 'Age'),
                  controller: txtAge,
                ),
                TextField(decoration: InputDecoration(labelText: 'Wallet value'),
                  controller: txtWalletValue,
                ),
                Text(error,style: TextStyle(color: Colors.red),),
                RaisedButton(child: Text('Create user'),
                  onPressed: (){
                    user.name = txtName.value.text;
                    user.age = int.parse(txtAge.value.text);
                    user.walletValue = double.parse(txtWalletValue.text);
                    DBHelper.db.InsertUser(user);
                    SharedData.sharedData.user = user;
                    while (Navigator.canPop(context)) Navigator.pop(context);
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new Homepage()));
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}