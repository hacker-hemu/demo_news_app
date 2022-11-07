class NewsImages {
  int? id;
  String? image;
  String? token;

  NewsImages({this.id, this.image, this.token});

  // function to convert json to category model
  factory NewsImages.fromJson(Map<String, dynamic> json) {
    return NewsImages(
      id: json['id'],
      image: json['image'],
      token: json['token'],
    );
  }
}
