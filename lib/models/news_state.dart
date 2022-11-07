class State {
  int? id;
  String? name;
  String? token;

  State({this.id, this.name, this.token});

  // function to convert json to category model
  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['state_id'],
      name: json['state_title'],
      token: json['token'],
    );
  }
}
