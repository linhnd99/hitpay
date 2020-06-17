

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Common/SharedData.dart';

import 'Models/Transaction.dart';
import 'Utils/DBHelper.dart';

class DialogAdd extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DialogAddState();
  }
}

class DialogAddState extends State<DialogAdd>{
  TextEditingController _txtContent = new TextEditingController();
  TextEditingController _txtValue = new TextEditingController();
  int selectRadio;

  @override
  void initState() {
    selectRadio=0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text("Add transaction",style: TextStyle(fontSize: 16),),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: Text("Submit",style: TextStyle(fontSize: 12,color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                onTap: (){
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


                  DBHelper.db.InsertTransaction(trans);
                  Navigator.of(context).pop();
                },
              ),
              InkWell(
                child: Text("Cancel",style: TextStyle(fontSize: 12,color: Colors.blueAccent),),
                onTap: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}