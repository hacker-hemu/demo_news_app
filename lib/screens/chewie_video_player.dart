import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoPlayer extends StatefulWidget {
  const ChewieVideoPlayer({Key? key}) : super(key: key);

  @override
  State<ChewieVideoPlayer> createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        'https://popular.livebox.co.in/PopularNewshls/live.m3u8');
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
    return Container(
      height: 200.0,
      color: Colors.black,
      child: Center(
        child: Chewie(
          controller: chewieController!,
        ),
      ),
    );
  }

  // disposing video player
  @override
  void dispose() {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }
}
