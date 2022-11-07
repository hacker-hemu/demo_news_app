import 'news.dart';

class Category {
  int? id;
  String? name;
  String? image;
  News? news;
  String? token;

  Category({this.id, this.name, this.image, this.news, this.token});

  // function to convert json to category model
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      token: json['token'],
    );
  }
}
