

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Common/SharedData.dart';

import 'Models/Transaction.dart';
import 'Utils/DBHelper.dart';

class DialogEditScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DialogEditState();
  }
}

class DialogEditState extends State<DialogEditScreen>{
  TextEditingController _txtContent = new TextEditingController();
  TextEditingController _txtValue = new TextEditingController();
  int selectRadio;
  int id;

  @override
  void initState() {
    selectRadio=SharedData.sharedData.currentTrans.type;
    this.id = SharedData.sharedData.currentTrans.id;
    _txtContent.text = SharedData.sharedData.currentTrans.content;
    _txtValue.text = moneyToString(SharedData.sharedData.currentTrans.value.round().toString());

  }

  String moneyToString(String value)
  {
    value=value.replaceAll(RegExp(','),'');
    int d=0;
    for (int i=value.length-1;i>=0;i--){
      d++;
      if (d%3==0){
        value = value.substring(0,i)+","+value.substring(i,value.length);
      }
    }
    if (value[0]==',') value=value.replaceRange(0, 1, '');
    return value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text("Edit transaction",style: TextStyle(fontSize: 16),),
          TextField(
            decoration: InputDecoration(
                labelText: "Content"
            ),
            controller: _txtContent,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Value",
            ),
            controller: _txtValue,
            onChanged: (String value){
              _txtValue.text = moneyToString(value);
            },
            keyboardType: TextInputType.number,
          ),
          RadioListTile(
            groupValue: selectRadio,
            value: 1,
            title: Text("Income", style: TextStyle(color: Colors.blueAccent),),
            selected: selectRadio == 1,
            onChanged: (value){
              setState(() {
                selectRadio = 1;
              });
            },
          ),
          RadioListTile(
            groupValue: selectRadio,
            value: 0,
            title: Text("Outcome",style: TextStyle(color: Colors.red),),
            selected: selectRadio == 0,
            onChanged: (value){
              setState(() {
                selectRadio = 0;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Delete',style: TextStyle(color: Colors.red),),
          onPressed: (){
            showDialog(context: context, builder: (context)=>AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you sure?')
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('YES'),
                  onPressed: () {
                    DBHelper.db.DeleteTransactionWithID(SharedData.sharedData.currentTrans.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
          },
        ),

        FlatButton(
          child: Text("Submit",style: TextStyle(color: Colors.blueAccent),),
          onPressed: (){
            Transactions trans = new Transactions();
            trans.content = _txtContent.value.text;
            trans.type = selectRadio;
            trans.value = double.parse(_txtValue.value.text.replaceAll(RegExp(','),''));
            trans.day = DateTime.now().day;
            trans.month = DateTime.now().month;
            trans.year = DateTime.now().year;

            if (trans.type == 0 && trans.value > SharedData.sharedData.user.walletValue) {
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text('Lỗi'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Số dư trong ví không đủ')
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });

              return ;
            }


            DBHelper.db.EditTransaction(trans);
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