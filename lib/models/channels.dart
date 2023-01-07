import 'package:demo_news_app/models/shows.dart';

class Channel {
  int? id;
  String? name;
  String? title;
  String? videLink;
  String? image;
  int? isPopular;
  int? isRecommended;
  // List<dynamic>? breakingNewsTitle;
  List<dynamic>? newsImages;
  String? videoLink;
  String? categoryName;
  Shows? shows;

  Channel({
    this.id,
    this.name,
    this.title,
    this.image,
    this.isPopular,
    this.isRecommended,
    this.newsImages,
    // this.breakingNewsTitle,
    this.videoLink,
    this.categoryName,
    this.shows,
  });

  // function to convert json to user model
  factory Channel.fromJson(Map<String, dynamic> json) {
    // print('model title is ' + json['title']);
    // print('model images is ' + json['news_image'].toString());
    return Channel(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      image: json['image'],
      isPopular: json['is_popular'],
      isRecommended: json['is_recommended'],
      newsImages: json['news_image'],
      // breakingNewsTitle: json['breaking_news_title'],
      videoLink: json['video_link'],
      categoryName: json['category_name'],
    );
  }
}
