import 'dart:io';

import 'package:hitpay/Models/User.dart';
import 'package:hitpay/Models/Transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper db = DBHelper._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "/HitpayDB.db";
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      print("create table start: "+path);
      await db.execute("CREATE TABLE USER (id integer primary key AUTOINCREMENT, name text, age integer, walletvalue float)");
      await db.execute("CREATE TABLE TRANSACTIONS (id integer primary key AUTOINCREMENT, content text, value integer, type bit, day integer, month integer, year integer)");
      print("Create table success");
    });
  }

  Future <String> getPathDB() async
  {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "/HitpayDB.db";
    return path;
  }

  InsertUser(User newUser) async {
    final db = await database;
    var res = await db.insert("USER", newUser.toMap());
    return res;
  }

  Future<User> getUser(int id) async {
    final db = await database;
    var res =await  db.query("USER", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : new User() ;
  }

  Future<List<User> >getAllUser() async{
    final db = await database;
    var res = await db.query("USER");
    List<User> resUser= new List<User>();
    for (Map<String,dynamic> one in res)
    {
        resUser.add(User.fromMap(one));
    }
    //List<User> list = res.isNotEmpty ? res.toList().map((c) => User.fromMap(c)) : new List<User>();
    return resUser;
  }

  InsertTransaction(Transactions trans) async {
    final db = await database;
    var res = await db.insert("TRANSACTIONS", trans.toJson());
    return res;
    //var res = await db.execute("INSERT INTO TRANSACTION VALUES (?,'?',?,?,'?')", );
  }

  Future<List<Transactions> >getAllTransactionDMY(int day, int month, int year) async{
    final db = await database;
    var res = await db.query("TRANSACTIONS", where: "day = ? and month = ? and year = ? ", whereArgs: [day,month,year]);
    List<Transactions> list= new List<Transactions>();
    for (Map<String,dynamic> one in res)
    {
      list.add(Transactions.fromMap(one));
    }
    //List<User> list = res.isNotEmpty ? res.toList().map((c) => User.fromMap(c)) : new List<User>();
    return list;
  }
  
  DropTable() async{
    final db = await database;
    await db.delete("TRANSACTIONS");
    await db.delete("USER");
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = documentsDirectory.path + "/HitpayDB.db";
//    await deleteDatabase(path);
  }
}