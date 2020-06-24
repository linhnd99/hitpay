import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Common/SharedData.dart';
import 'package:hitpay/Models/Transaction.dart';
import 'package:hitpay/Utils/DBHelper.dart';

class DialogPaidScreen extends StatefulWidget {

  Transactions trans;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DialogPaidScreenState();
  }
}

class DialogPaidScreenState extends State<DialogPaidScreen>{

  Transactions trans;
  TextEditingController txtPaid;

  @override
  void initState() {
    // TODO: implement initState
    trans = SharedData.sharedData.currentTrans;
    txtPaid = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text("Pay "+trans.content),
      content: TextField(
        decoration: InputDecoration(
          labelText: "Value",
          suffix: Container(
            height: 30,
            child: FlatButton(
              child: Text(trans.value.toString(),style: TextStyle(fontSize:10),),
              onPressed: (){
                txtPaid.text = trans.value.toInt().toString();
              },
            ),
          )
        ),
        controller: txtPaid,
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Submit",style: TextStyle(color: Colors.blueAccent),),
          onPressed: (){
            try{
              if (double.parse(txtPaid.text) > trans.value) {
                showDialog(context: context, builder: (context)=>AlertDialog(
                  content: Text("Value is invalid"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
                return;
              }
            }
            catch (ex) {
              showDialog(context: context, builder: (context)=>AlertDialog(
                content: Text("Value is invalid"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
              return ;
            }

            if (double.parse(txtPaid.text) == trans.value) {
              DBHelper.db.DeleteTransactionWithID(trans.id);
            }
            else {
              trans.value -= double.parse(txtPaid.text);
              SharedData.sharedData.user.walletValue-=double.parse(txtPaid.text);
              DBHelper.db.UpdateUser(SharedData.sharedData.user);
              DBHelper.db.EditTransaction(trans);
            }
            Navigator.pop(context);
          }
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