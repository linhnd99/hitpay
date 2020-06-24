import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Cells/BorrowCell.dart';
import 'package:hitpay/Common/SharedData.dart';
import 'package:hitpay/DialogAddBorrowScreen.dart';
import 'package:hitpay/DialogPaidScreen.dart';
import 'package:hitpay/Models/Transaction.dart';
import 'package:hitpay/Utils/DBHelper.dart';

import 'Common/ColorDF.dart';

class BorrowScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BorrowScreenState();
  }
}

class BorrowScreenState extends State<BorrowScreen> {

  List<Transactions> listTrans;

  @override
  void initState() {
    listTrans = new List<Transactions>();
    DBHelper.db.getAllBorrows().then((list){
      setState(() {
        listTrans=list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorDF.Appbar,
        title: Text("Borrow - Pay"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: (listTrans.length==0?Center(child: Text("No transaction",style: TextStyle(color:Colors.grey),),):ListView.builder(
              itemCount: listTrans.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  child: BorrowCell(trans:listTrans[index]),
                  onTap: (){
                    SharedData.sharedData.currentTrans = listTrans[index];
                    showDialog(context: context,builder: (context)=>new DialogPaidScreen()).then((onValue){
                      DBHelper.db.getAllBorrows().then((list){
                        setState(() {
                          listTrans = list;
                        });
                      });
                    });
                  },
                );
              },
            )),
          ),

          Container(
            padding: EdgeInsets.only(right: 20,bottom: 20),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: ColorDF.Appbar2,
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: (){
                showDialogAdd().then((onValue){
                  DBHelper.db.getAllBorrows().then((list){
                    setState(() {
                      listTrans = list;
                    });
                  });
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Future showDialogAdd() {
    return showDialog(context: context,builder: (context)=>DialogAddBorrowScreen());
  }
}