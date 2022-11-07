class Ads {
  int? id;
  String? name;
  String? image;
  String? link;
  String? mobileNumber;
  String? token;

  Ads({
    this.id,
    this.name,
    this.image,
    this.link,
    this.mobileNumber,
    this.token,
  });

  // function to convert json to category model
  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      link: json['go_link'],
      mobileNumber: json['call_number'],
      token: json['token'],
    );
  }
}
