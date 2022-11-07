class City {
  int? id;
  String? name;
  String? token;

  City({this.id, this.name, this.token});

  // function to convert json to category model
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      token: json['token'],
    );
  }
}
