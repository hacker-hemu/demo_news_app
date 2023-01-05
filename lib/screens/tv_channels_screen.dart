import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/models/channels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../components/ads.dart';
import '../components/likeCommentShare.dart';
import '../components/main_news_post_title.dart';
import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/news.dart';
import '../models/user.dart';
import '../services/ads_service.dart';
import '../services/channels_service.dart';
import '../services/news_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class TvChannelsScreen extends StatefulWidget {
  const TvChannelsScreen({Key? key, required this.channel}) : super(key: key);
  final Channel channel;

  @override
  State<TvChannelsScreen> createState() => _TvChannelsScreenState();
}

class _TvChannelsScreenState extends State<TvChannelsScreen> {
  // save ads
  List<dynamic> _adsList = [];

  // save news
  List<dynamic> _channelsList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all ads
  Future<void> retriveAds() async {
    userId = await getUserId();
    ApiResponse response = await getAdsDetail();

    print('user id is for ads in tv screen => $userId');

    // if no error so get all ads in _adsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting ads data in tv screen');
        _adsList = response.data as List<dynamic>;
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

  // getting all news
  Future<void> retriveChannels() async {
    userId = await getUserId();
    ApiResponse response = await getChannels();

    print('user id for channels => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting news data');

        _channelsList = response.data as List<dynamic>;

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

  late YoutubePlayerController controller;

  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // getting news from main news screen
    Channel channel = widget.channel;
    return SafeArea(
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) => Scaffold(
          body: Column(
            children: [
              player,
              SizedBox(
                height: 5.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  likeShareComment(
                    label: '',
                    icon: FontAwesomeIcons.heart,
                  ),
                  likeShareComment(
                    label: '',
                    icon: FontAwesomeIcons.link,
                  ),
                  likeShareComment(
                    label: '',
                    icon: FontAwesomeIcons.share,
                    onPressed: () {
                      Share.share(
                          'न्यूज़ के लिए आज ही ऐप इंस्टॉल करें।\n\n$playStoreAppLink\n\n\nसंपर्क करें: $clientMobileNumber\nEmail: $clientEmail\n\n\n',
                          subject: 'Look what I made!');
                    },
                  ),
                ],
              ),

              SizedBox(
                height: 5.0,
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 16 / 9,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: _channelsList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      Channel channels = _channelsList[index];
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(channels.name.toString()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // init state
  @override
  void initState() {
    super.initState();

    retriveChannels();

    String? url;
    url = YoutubePlayer.convertUrlToId(widget.channel.videoLink.toString());

    print(url);

    controller = YoutubePlayerController(
      initialVideoId: url.toString(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        // disableDragSeek: false,
        // loop: false,
        // isLive: false,
        // forceHD: false,
        // enableCaption: true,
      ),
    );
  }

  // disposing speaking
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
