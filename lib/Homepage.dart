

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hitpay/Cells/TransactionCell.dart';
import 'package:hitpay/Common/SharedData.dart';
import 'package:hitpay/CreateUserScreen.dart';
import 'package:hitpay/Models/Transaction.dart';
import 'package:hitpay/Utils/DBHelper.dart';

import 'DialogAddScreen.dart';
import 'Models/User.dart';
import 'Utils/FormatDate.dart';

class Homepage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomepageState();
  }
}

class HomepageState extends State<Homepage>{
  List<User> listUser;
  List<Transactions> listTrans;
  bool isCreate = false;
  String strIncome="",strOutcome="", strBalance="";
  int selectRadio;



  @override
  void initState() {
    // TODO: implement initState
    SharedData.sharedData.user = new User();
    listTrans = new List<Transactions>();

    DBHelper.db.getAllUser().then((list){
      setState(() {
        listUser = list;
        if (list.length == 0) {
          Navigator.push(context, new MaterialPageRoute(builder: (context)=>new CreateUserScreen())).then((onValue){
            setState(() {});
          });
          return ;
        }
        else SharedData.sharedData.user = list.first;
      });
    });

    DBHelper.db.getAllTransactionDMY(DateTime.now().day,DateTime.now().month,DateTime.now().year).then((list){
      setState(() {
        listTrans=list;
        double income=0, outcome = 0;
        for (Transactions trans in listTrans){
          if (trans.type == 1) income += trans.value;
          else outcome += trans.value;
        }
        strIncome = income.toString();
        strOutcome = outcome.toString();
        strBalance = ((income>outcome)?"+":"")+(income-outcome).toString();
      });
    });

    selectRadio=0;
    super.initState();
  }

  Widget Waiting(){
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWanderingCubes(
            color: Colors.blueAccent,
            size: 50,
          ),
          Padding(
            padding: EdgeInsets.only(top:30),
            child: Text('Hitpay',style: TextStyle(color: Colors.blueAccent, fontSize: 20),),
          )
        ],
      ),
    );
  }

  Future UpdateListTrans(bool check) async {
    int day=DateTime.now().day;
    int month=DateTime.now().month;
    int year=DateTime.now().year;
    DBHelper.db.getAllTransactionDMY(day, month, year).then((list){
      listTrans=list;
      double income=0, outcome = 0;
      for (Transactions trans in listTrans){
        if (trans.type == 1) income += trans.value;
        else outcome += trans.value;
      }
      strIncome = income.toString();
      strOutcome = outcome.toString();
      strBalance = ((income>outcome)?"+":"")+(income-outcome).toString();
    });
    return !check;
  }



  @override
  Widget build(BuildContext context) {

    if (SharedData.sharedData.user==null) return Waiting();
    return listUser == null ? Waiting() : Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            child: Text(SharedData.sharedData.user.walletValue.toString()+" VND", style: TextStyle(color:Colors.white, fontStyle: FontStyle.italic, fontSize: 12),),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SpinKitWanderingCubes(
                      color: Colors.blueAccent,
                      size: 50,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("Name: ",style: TextStyle(fontSize: 16),),
                      Text(SharedData.sharedData.user.name==null?"":SharedData.sharedData.user.name,style: TextStyle(color: Colors.purple, fontSize: 16),)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Wallet:", style: TextStyle(fontSize: 16),),
                      Text(SharedData.sharedData.user.walletValue.toString() +" VND",style: TextStyle(color:Colors.red, fontSize: 16),)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top:5),
                child: Text(FormatDate.ToString(DateTime.now()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),

              Container(
                margin: EdgeInsets.only(left:10,right:10),
                height: 120,
                child: Card(
                    elevation: 5,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text("Income",style: TextStyle(color: Colors.white),),
                                  Text("+"+strIncome,style: TextStyle(color: Colors.white),)
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent
                              ),
                              height: 120,
                              width: MediaQuery.of(context).size.width/2-14,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text("Outcome",style: TextStyle(color: Colors.white),),
                                  Text("-"+strOutcome,style: TextStyle(color: Colors.white),)
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.pinkAccent
                              ),
                              height: 120,
                              width: MediaQuery.of(context).size.width/2-14,
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width/2-100,
                              height: 80,
                              child: Column(
                                children: <Widget>[
                                  Text("Balance",style: TextStyle(color: Colors.black),),
                                  Text(strBalance,style: TextStyle(color: Colors.black),)
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ),

              // ListView.builder transactions
              (listTrans.length==0)?Container(padding: EdgeInsets.only(top:20), child: Text("No transaction",style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center,),):Container(
                height: MediaQuery.of(context).size.height-255,
                child: ListView.builder(
                  itemCount: listTrans.length,
                  itemBuilder: (BuildContext context, int index){
                    Transactions trans = listTrans[index];
                    return TransactionCell(context, trans);
                  },
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(right:10,bottom: 10),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              child: Icon(Icons.add),
              onPressed: () {
                CreateDialogAdd(context).then((onValue){
                  int day=DateTime.now().day;
                  int month=DateTime.now().month;
                  int year=DateTime.now().year;
                  DBHelper.db.getAllTransactionDMY(day, month, year).then((list){
                    setState(() {
                      listTrans=list;
                      double income=0, outcome = 0;
                      for (Transactions trans in listTrans){
                        if (trans.type == 1) income += trans.value;
                        else outcome += trans.value;
                      }
                      strIncome = income.toString();
                      strOutcome = outcome.toString();
                      strBalance = ((income>outcome)?"+":"")+(income-outcome).toString();
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

  Future CreateDialogAdd(BuildContext context)
  {
    return showDialog(context: context, builder: (context){
      return DialogAdd();
    });
  }
}
