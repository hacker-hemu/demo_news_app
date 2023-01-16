import 'package:demo_news_app/models/user.dart';

import 'news_category.dart';

class News {
  int? id;
  String? title;
  String? titleColor;
  String? news_desc;
  String? content;
  String? image;
  int? likesCount;
  String? approved;
  User? user;
  String? creatorImage;
  String? creatorName;
  String? categoryImage;
  String? categoryName;
  Category? category;
  List<dynamic>? breakingNewsTitle;
  List<dynamic>? newsImages;
  bool? selfLiked;
  int? addToTicker;
  String? stateName;
  String? districtName;
  String? cityName;
  String? created_at;
  String? loggedInUserState;
  String? loggedInUserDistrict;
  String? loggedInUserCity;
  String? videoLink;
  int? status;

  News({
    this.id,
    this.title,
    this.titleColor,
    this.news_desc,
    this.content,
    this.image,
    this.likesCount,
    this.approved,
    this.user,
    this.newsImages,
    this.creatorImage,
    this.creatorName,
    this.categoryImage,
    this.breakingNewsTitle,
    this.categoryName,
    this.category,
    this.selfLiked,
    this.addToTicker,
    this.stateName,
    this.districtName,
    this.cityName,
    this.created_at,
    this.loggedInUserState,
    this.loggedInUserDistrict,
    this.loggedInUserCity,
    this.videoLink,
    this.status,
  });

  // function to convert json to user model
  factory News.fromJson(Map<String, dynamic> json) {
    // print('model title is ' + json['title']);
    // print('model images is ' + json['news_image'].toString());
    return News(
      id: json['id'],
      title: json['title'],
      titleColor: json['title_color'],
      news_desc: json['news_desc'],
      content: json['content'],
      image: json['image'],
      likesCount: json['likes_count'],
      approved: json['approved'],
      selfLiked: json['likes'].length > 0,
      addToTicker: json['add_to_ticker'],
      user: User(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
      ),
      newsImages: json['news_image'],
      breakingNewsTitle: json['breaking_news_title'],
      creatorImage: json['creator_image'],
      creatorName: json['creator_name'],
      categoryImage: json['category_image'],
      categoryName: json['category_name'],
      // category: Category(
      //   id: json['category']['id'],
      //   name: json['category']['name'],
      //   image: json['category']['image'],
      // ),
      stateName: json['state_name'],
      districtName: json['district_name'],
      cityName: json['city_name'],
      created_at: json['readable_time'],
      loggedInUserState: json['loggedInUserState'],
      loggedInUserDistrict: json['loggedInUserDistrict'],
      loggedInUserCity: json['loggedInUserCity'],
      videoLink: json['video_link'],
      status: json['status'],
    );
  }
}
