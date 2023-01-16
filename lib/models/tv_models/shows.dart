class Shows {
  int? id;
  String? name;
  String? title;
  String? videLink;
  String? image;
  int? isLive;
  List<dynamic>? newsImages;
  String? videoLink;
  int? channelId;

  Shows({
    this.id,
    this.name,
    this.title,
    this.image,
    this.isLive,
    this.newsImages,
    this.videoLink,
    this.channelId,
  });

  // function to convert json to user model
  factory Shows.fromJson(Map<String, dynamic> json) {
    // print('model title is ' + json['title']);
    // print('model images is ' + json['news_image'].toString());
    return Shows(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      image: json['image'],
      isLive: json['is_live'],
      newsImages: json['news_image'],
      // breakingNewsTitle: json['breaking_news_title'],
      videoLink: json['video_link'],
      channelId: json['channel_id'],
    );
  }
}
