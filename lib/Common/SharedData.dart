import 'package:hitpay/Models/Transaction.dart';
import 'package:hitpay/Models/User.dart';

class SharedData {
  SharedData._();
  static SharedData sharedData = SharedData._();

  User user;
  Transactions currentTrans;
}