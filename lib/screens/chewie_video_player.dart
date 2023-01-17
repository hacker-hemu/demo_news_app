import 'package:chewie/chewie.dart';
import 'package:demo_news_app/screens/tv_screens/video_items.dart';
import 'package:demo_news_app/services/tv_services/live_tv_video_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'login.dart';

class ChewieVideoPlayer extends StatefulWidget {
  const ChewieVideoPlayer({Key? key}) : super(key: key);

  @override
  State<ChewieVideoPlayer> createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  // save all channels
  List<dynamic> _liveTvVideoList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all news
  Future<void> retriveLiveTvVideo() async {
    userId = await getUserId();
    ApiResponse response = await getLiveTvVideo();

    debugPrint('user id for live video => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting Live Video data');

        _liveTvVideoList = response.data as List<dynamic>;

        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    retriveLiveTvVideo();
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network('Video Link');
    // await Future.wait([videoPlayerController!.initialize()]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      fullScreenByDefault: false,
      deviceOrientationsAfterFullScreen: [
        // DeviceOrientation.portraitUp,
        // DeviceOrientation.portraitDown,
      ],
      showControls: true,
      aspectRatio: 16 / 9,
      showOptions: true,
      autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return !_loading
        ? Container(
            height: _liveTvVideoList.isNotEmpty ? 200.0 : 0,
            color: Colors.black,
            child: Center(
              child: _liveTvVideoList.isNotEmpty
                  ? VideoItems(
                      videoPlayerController: VideoPlayerController.network(
                          _liveTvVideoList[0].videoLink ??
                              'https://popular.livebox.co.in/PopularNewshls/live.m3u8'),
                      looping: false,
                      autoplay: true,
                    )
                  :
                  // default video
                  Container(),
            ),
          )
        : Container();
  }

  // disposing video player
  @override
  void dispose() {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }
}
