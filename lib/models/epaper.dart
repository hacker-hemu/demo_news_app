class Epaper {
  int? id;
  String? name;
  String? image;
  String? date;
  String? created_at;
  String? token;

  Epaper({
    this.id,
    this.name,
    this.image,
    this.date,
    this.created_at,
    this.token,
  });

  // function to convert json to epaper model
  factory Epaper.fromJson(Map<String, dynamic> json) {
    return Epaper(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      date: json['date'],
      created_at: json['created_at'],
      token: json['token'],
    );
  }
}
