import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Models/Transaction.dart';
import 'package:hitpay/Utils/FormatDate.dart';

class BorrowCell extends StatelessWidget{

  Transactions trans;

  BorrowCell({this.trans});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 70,
      padding: EdgeInsets.only(left:20, right:20,top:10),
      child: Card(
        elevation: 3,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left:10),
              alignment: Alignment.centerLeft,
              child: Text(trans.day.toString()+"/"+trans.month.toString()+"/"+trans.year.toString()+" - Borrow: "+trans.content, style: TextStyle(color: Colors.blueAccent),),
            ),

            Container(
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(trans.value.toString(), style: TextStyle(color: Colors.blueAccent),),
            ),
          ],
        )
      ),
    );
  }
}