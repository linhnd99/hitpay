import 'dart:convert';

class User{
  int id;
  String name;
  int age;
  double walletValue;

  User({
    this.id,
    this.name,
    this.age,
    this.walletValue,
  });

  @override
  String toString() {
    // TODO: implement toString
    return name+" "+age.toString()+" "+walletValue.toString();
  }

  static fromMap(Map<String, dynamic> json) => new User(
    id: json["id"],
    name: json["name"],
    //age: int.parse(json["age"].toString()),
    age: json["age"],
    walletValue: json["walletvalue"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "age": age,
    "walletvalue": walletValue,
  };
}

User clientFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String clientToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}