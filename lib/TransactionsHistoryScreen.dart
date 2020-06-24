
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Cells/TransactionCell.dart';
import 'package:hitpay/Common/SharedData.dart';
import 'package:hitpay/DialogEditScreen.dart';
import 'package:hitpay/Models/Transaction.dart';
import 'package:hitpay/Utils/DBHelper.dart';



import 'Common/ColorDF.dart';
import 'Utils/FormatDate.dart';

class TransactionsHistoryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TransactionsHistoryScreenState();
  }
}

class TransactionsHistoryScreenState extends State<TransactionsHistoryScreen>{

  List<Transactions> listTrans;
  DateTime _selectedDate;

  @override
  void initState() {

    _selectedDate = DateTime.now();


    listTrans = new List<Transactions>();

    LoadListTrans(DateTime.now());
  }


  void LoadListTrans(DateTime date)
  {
    int day = date.day;
    int month = date.month;
    int year = date.year;
    DBHelper.db.getAllTransactionDMY(day, month, year).then((list){
      setState(() {
        listTrans = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions history"),
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorDF.Appbar,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left:20, right:20,top:10),
            child: CupertinoDateTextBox(
              initialValue: _selectedDate,
              color: Colors.black,
              fontSize: 14,
              onDateChange: (DateTime date){
                _selectedDate = date;
                DBHelper.db.getAllTransactionDMY(_selectedDate.day, _selectedDate.month, _selectedDate.year).then((list){
                  setState(() {
                    listTrans=list;
                  });
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, right:10),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height-149,
            child: ListView.builder(
              itemCount: listTrans.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  child: TransactionCell(context, listTrans[index]),
                  onTap: (){
                    SharedData.sharedData.currentTrans = listTrans[index];
                    showDialog(context: context, builder: (context)=>DialogEditScreen()).then((onValue){
                      DBHelper.db.getAllTransactionDMY(_selectedDate.day, _selectedDate.month, _selectedDate.year).then((list){
                        setState(() {
                          listTrans = list;
                        });
                      });
                    });
                  },);
              },
            ),
          )
        ],
      )
    );
  }
}