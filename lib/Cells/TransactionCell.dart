import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitpay/Models/Transaction.dart';

Widget TransactionCell(BuildContext context, Transactions trans)
{
  return ListTile(
    title: Container(
      height: 70,
      child: Card(
        elevation: 3,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left:10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width-100,
              child: Text((trans.type==3?"borrow: ":"")+trans.content),
            ),
            Container(
              padding: EdgeInsets.only(right:10),
              alignment: Alignment.centerRight,
              child: Text((trans.type==0?"-":"+")+trans.value.toString(),style: TextStyle(color: (trans.type==0?Colors.red:Colors.blueAccent)),),
            )
          ],
        ),
      ),
    )
  );
}