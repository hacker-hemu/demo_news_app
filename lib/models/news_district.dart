class District {
  int? id;
  String? name;
  String? token;

  District({this.id, this.name, this.token});

  // function to convert json to category model
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['districtid'],
      name: json['district_title'],
      token: json['token'],
    );
  }
}
