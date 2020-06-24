import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Common/SharedData.dart';
import 'Models/Transaction.dart';
import 'Utils/DBHelper.dart';

class DialogAddBorrowScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DialogAddBorrowScreenState();
  }
}

class DialogAddBorrowScreenState extends State<DialogAddBorrowScreen> {
  TextEditingController _txtContent = new TextEditingController();
  TextEditingController _txtValue = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text("Add borrow",style: TextStyle(fontSize: 16),),
          TextField(
            decoration: InputDecoration(
                labelText: "Who?"
            ),
            controller: _txtContent,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Value",
            ),
            controller: _txtValue,
            onChanged: (String value){
              value=value.replaceAll(RegExp(','),'');
              int d=0;
              for (int i=value.length-1;i>=0;i--){
                d++;
                if (d%3==0){
                  value = value.substring(0,i)+","+value.substring(i,value.length);
                  //i-=2;
                }
              }
              if (value[0]==',') value=value.replaceRange(0, 1, '');
              _txtValue.text = value;
            },
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Submit",style: TextStyle(color: Colors.blueAccent),),
          onPressed: (){
            Transactions trans = new Transactions();
            trans.content = _txtContent.value.text;
            trans.type = 3;
            trans.value = double.parse(_txtValue.value.text.replaceAll(RegExp(','),''));
            trans.day = DateTime.now().day;
            trans.month = DateTime.now().month;
            trans.year = DateTime.now().year;

            DBHelper.db.InsertTransaction(trans);
            SharedData.sharedData.user.walletValue+=trans.value;
            DBHelper.db.UpdateUser(SharedData.sharedData.user);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Cancel",style: TextStyle(color: Colors.red),),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}