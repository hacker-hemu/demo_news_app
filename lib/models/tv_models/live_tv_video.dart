class LiveTvVideo {
  int? id;
  String? name;
  String? title;
  String? videoLink;
  String? image;

  LiveTvVideo({
    this.id,
    this.name,
    this.title,
    this.videoLink,
    this.image,
  });

  // function to convert json to user model
  factory LiveTvVideo.fromJson(Map<String, dynamic> json) {
    return LiveTvVideo(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      videoLink: json['video_link'],
      image: json['image'],
    );
  }
}
