class VideoNews {
  int? id;
  // String? title;
  // String? news_desc;
  // String? image;
  // int? likesCount;
  // String? approved;
  // User? user;
  // String? creatorImage;
  // String? creatorName;
  // List<dynamic>? newsImages;
  // bool? selfLiked;
  // String? stateName;
  // String? districtName;
  // String? cityName;
  // String? created_at;
  String? videoLink;

  VideoNews({
    this.id,
    // this.title,
    // this.news_desc,
    // this.image,
    // this.likesCount,
    // this.approved,
    // this.user,
    // this.newsImages,
    // this.creatorImage,
    // this.creatorName,
    // this.selfLiked,
    // this.stateName,
    // this.districtName,
    // this.cityName,
    // this.created_at,
    this.videoLink,
  });

  // function to convert json to user model
  factory VideoNews.fromJson(Map<String, dynamic> json) {
    print('model title is ' + json['video_link']);
    // print('model images is ' + json['news_image'].toString());
    return VideoNews(
      id: json['id'],
      // title: json['title'],
      // news_desc: json['news_desc'],
      // image: json['image'],
      // likesCount: json['likes_count'],
      // approved: json['approved'],
      // selfLiked: json['likes'].length > 0,
      // user: User(
      //   id: json['user']['id'],
      //   name: json['user']['name'],
      //   image: json['user']['image'],
      // ),
      // newsImages: json['news_image'],
      // creatorImage: json['creator_image'],
      // creatorName: json['creator_name'],
      // created_at: json['readable_time'],
      videoLink: json['video_link'],
    );
  }
}
