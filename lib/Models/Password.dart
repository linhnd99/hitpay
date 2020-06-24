class Password {

  int id;
  String password;

  Password({this.id, this.password});

  static fromMap(Map<String, dynamic> json) => new Password(
    id: json["id"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "id":id,
    "password":password
  };
}