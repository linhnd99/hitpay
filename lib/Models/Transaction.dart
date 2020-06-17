class Transactions {
  int id;
  String content;
  double value;
  int type;
  int day;
  int month;
  int year;

  Transactions(
      {this.id, this.content, this.value, this.type, this.day, this.month, this.year});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    value = double.parse(json['value'].toString());
    type = int.parse(json['type'].toString());
    day = int.parse(json['day'].toString());
    month = int.parse(json['month'].toString());
    year = int.parse(json['year'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['value'] = this.value;
    data['type'] = this.type;
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    return data;
  }

  static fromMap(Map<String, dynamic> json) => new Transactions(
    id: json["id"],
    content: json["content"],
    type: (json["type"].toString() == "1")?1:0,
    value: double.parse(json["value"].toString()),
    day: json["day"],
    month: json["month"],
    year: json["year"],
  );

//  Map<String, dynamic> toMap() => {
//    'id':this.id,
//    'content':this.content,
//    'value': this.value,
//    'type': this.type,
//    'datetime': this.datetime
//  };
}