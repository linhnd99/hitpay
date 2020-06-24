import 'dart:io';

import 'package:hitpay/Models/Password.dart';
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
      await db.execute("CREATE TABLE TRANSACTIONS (id integer primary key AUTOINCREMENT, content text, value integer, type integer, day integer, month integer, year integer)");
      await db.execute("CREATE TABLE PASSWORD (id integer, password text)");
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

  UpdateUser(User user) async {
    final db = await database;
    var res = await db.update("USER", user.toMap(), where: "id = ?", whereArgs: [user.id]);
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
    return resUser;
  }



  Future<List<Transactions>> getAllBorrows() async {
    final db = await database;
    var res = await db.query("TRANSACTIONS", where: "type = ?",whereArgs: [3]);
    List<Transactions> list= new List<Transactions>();
    for (Map<String,dynamic> one in res)
    {
      list.add(Transactions.fromMap(one));
    }
    return list;
  }

  InsertTransaction(Transactions trans) async {
    final db = await database;
    var res = await db.insert("TRANSACTIONS", trans.toJson());
    return res;
  }

  Future<List<Transactions> >getAllTransactionDMY(int day, int month, int year) async{
    final db = await database;
    var res = await db.query("TRANSACTIONS", where: "day = ? and month = ? and year = ? ", whereArgs: [day,month,year]);
    List<Transactions> list= new List<Transactions>();
    for (Map<String,dynamic> one in res)
    {
      list.add(Transactions.fromMap(one));
    }
    return list;
  }

  DeleteTransactionWithID(int id) async
  {
    final db = await database;
    var res = await db.delete("TRANSACTIONS",where: "id = ?", whereArgs: [id]);
  }

  EditTransaction(Transactions trans) async
  {
    final db = await database;
    var res = await db.update("TRANSACTIONS", trans.toJson(),where:"id = ?",whereArgs: [trans.id]);
  }

  InsertPassword(Password pass) async {
    final db = await database;
    var res = await db.insert("PASSWORD", pass.toMap());
    return res;
  }

  UpdatePassword(Password pass) async{
    final db = await database;
    var res = await db.update("PASSWORD", pass.toMap(),where: "id = ?", whereArgs: [pass.id]);
    return res;
  }

  DeletePassword(Password pass) async {
    final db = await database;
    var res = await db.delete("PASSWORD",where: "id = ?",whereArgs: [pass.id]);
    return res;
  }

  getPassword() async {
    final db = await database;
    var res = await db.query("PASSWORD");
    List<Password> list = new List<Password>();
    for (Map<String,dynamic> json in res) {
      Password one  = Password.fromMap(json);
      list.add(one);
    }
    if (list.length == 0) return "";
    return list.first.password;
  }

  
  DropTable() async{
    final db = await database;
    await db.delete("TRANSACTIONS");
    await db.delete("USER");
    await db.delete("PASSWORD");
  }
}