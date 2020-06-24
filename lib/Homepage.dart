

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hitpay/BorrowScreen.dart';
import 'package:hitpay/Cells/TransactionCell.dart';
import 'package:hitpay/ChangePasswordScreen.dart';
import 'package:hitpay/Common/SharedData.dart';
import 'package:hitpay/CreateUserScreen.dart';
import 'package:hitpay/Models/Transaction.dart';
import 'package:hitpay/TransactionsHistoryScreen.dart';
import 'package:hitpay/Utils/DBHelper.dart';

import 'Common/ColorDF.dart';
import 'Common/Common.dart';
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
        ComputeBalance();
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
            color: Colors.black,
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
      ComputeBalance();
    });
    return !check;
  }



  @override
  Widget build(BuildContext context) {

    if (SharedData.sharedData.user==null) return Waiting();
    return listUser == null ? Waiting() : Scaffold(
      appBar: AppBar(
        backgroundColor: ColorDF.Appbar,
        title: Text("Dashboard"),
        actions: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right:20),
              child: Text(SharedData.sharedData.user.walletValue.toString()+" VND", style: TextStyle(color:Colors.white, fontStyle: FontStyle.italic, fontSize: 12),),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: ColorDF.Appbar,
              ),
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
                      Text("Name: ",style: TextStyle(fontSize: 16,color: Colors.white),),
                      Text(SharedData.sharedData.user.name==null?"":SharedData.sharedData.user.name,style: TextStyle(color: Colors.white, fontSize: 16),)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Wallet: ", style: TextStyle(fontSize: 16,color: Colors.white),),
                      Text(SharedData.sharedData.user.walletValue.toString() +" VND",style: TextStyle(color:Colors.white, fontSize: 16),)
                    ],
                  )
                ],
              ),
            ),

            ListTile(
              title: Text("Borrow - pay"),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context)=>new BorrowScreen())).then((onValue){
                  DBHelper.db.getAllTransactionDMY(DateTime.now().day, DateTime.now().month, DateTime.now().year).then((list){
                    setState(() {
                      listTrans=list;
                      ComputeBalance();
                    });
                  });
                });
              },
            ),

            ListTile(
              title: Text('Manage transactions history'),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context)=> new TransactionsHistoryScreen())).then((onValue){
                  DBHelper.db.getAllTransactionDMY(DateTime.now().day, DateTime.now().month, DateTime.now().year).then((list){
                    setState(() {
                      listTrans=list;
                      ComputeBalance();
                    });
                  });
                });
              },
            ),

            ListTile(
              title: Text('Change password'),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new ChangePasswordScreen()));
              },
            ),

            ListTile(
              title: Text('Reset database'),
              onTap: (){
                DBHelper.db.DropTable().then((onValue){

                });
              },
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
                child: Text(FormatDate.ToString(DateTime.now()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              ),

              Container(
                margin: EdgeInsets.only(left:10,right:10),
                height: 120,
                child: Card(
                    elevation: 3,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text("Income",style: TextStyle(color: Colors.black),),
                                  Text("+"+strIncome,style: TextStyle(color: Colors.black),)
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              decoration: BoxDecoration(
                                  color: ColorDF.Income,
                              ),
                              height: 120,
                              width: MediaQuery.of(context).size.width/2-14,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text("Outcome",style: TextStyle(color: Colors.black),),
                                  Text("-"+strOutcome,style: TextStyle(color: Colors.black),)
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              decoration: BoxDecoration(
                                  color: ColorDF.Outcome,
                              ),
                              height: 120,
                              width: MediaQuery.of(context).size.width/2-14,
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorDF.Balance,
                              borderRadius: BorderRadius.circular(4),
                            ),
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
            margin: EdgeInsets.only(right:20,bottom: 20),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: ColorDF.Appbar2,
              child: Icon(Icons.add),
              onPressed: () {
                CreateDialogAdd(context).then((onValue){
                  int day=DateTime.now().day;
                  int month=DateTime.now().month;
                  int year=DateTime.now().year;
                  DBHelper.db.getAllTransactionDMY(day, month, year).then((list){
                    setState(() {
                      listTrans=list;
                      ComputeBalance();
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

  void ComputeBalance()
  {
    double income=0, outcome = 0;
    for (Transactions trans in listTrans){
      if (trans.type == 0) outcome += trans.value;
      else income += trans.value;
    }
    strIncome = Common.FormatMoney(income.toInt().toString());
    strOutcome = Common.FormatMoney(outcome.toInt().toString());
    strBalance = ((income>outcome)?"+":"")+Common.FormatMoney((income-outcome).toInt().toString());
  }

  Future CreateDialogAdd(BuildContext context)
  {
    return showDialog(context: context, builder: (context){
      return DialogAdd();
    });
  }
}
