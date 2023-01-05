import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/models/channels.dart';
import 'package:demo_news_app/screens/chewie_video_player.dart';
import 'package:demo_news_app/screens/show_single_news.dart';
import 'package:demo_news_app/screens/tv_channels_screen.dart';
import 'package:flutter/material.dart';

import '../components/ads.dart';
import '../components/category.dart';
import '../components/main_news_post_title.dart';
import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/ads_service.dart';
import '../services/channels_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({Key? key}) : super(key: key);

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
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

  // init state
  @override
  void initState() {
    debugPrint('=========== news retrieve function called ==============');
    retriveChannels();

    debugPrint('=========== top ads retrieve function called ==============');
    retriveAds();

    super.initState();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // color: Color(0xff0c111b),
        child: Column(
          children: [
            // ChewieVideoPlayer(),

            SizedBox(
              height: 5.0,
            ),

            // carousel for advertisement
            _adsList.isEmpty
                ?
                // static ad image TODO: replace with news image when test ad image is ready
                Container(
                    // width: double.infinity,
                    child: Card(
                      elevation: 5.0,
                      semanticContainer: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              defaultAdImage,
                            ),
                          ),

                          // carousel title

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0),
                                    Colors.black,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 15.0,
                              ),
                              child: const Center(
                                child: Text(
                                  'Ads Title',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Advertisement(loading: _loading, list: _adsList),

            // channels
            if (_loading)
              Container(
                height:
                    // MediaQuery.of(context).size.height - 350.0,
                    300.0,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  Channel channels = _channelsList[index];
                  // print('hello');
                  // print('news image ' +
                  //     news.newsImages.toString());
                  try {
                    // print('news image ' +
                    //     news.newsImages.toString());
                    return InkWell(
                        child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // category  title
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const[
                              Text(
                                'Channels',
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                               const Icon(Icons.arrow_forward_ios, size: 15.0,),
                            ],
                          ),
                        ),

                        // all channel in slider view
                        SizedBox(
                          child: _loading
                              ? Container(
                            height: 200.0,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : CarouselSlider(
                            // carousel option for category
                            options: CarouselOptions(
                              height: 150.0,
                              viewportFraction: 0.75,
                              // enableInfiniteScroll: false,
                              autoPlay: false,
                            ),
                            // TODO: change the variable name news to ad when adding advertisment api
                            items: _channelsList.map(
                                  (single_channel) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    try {
                                      return InkWell(

                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) {
                                                // TODO: redirecting to user_screen
                                                // return Container();
                                                return TvChannelsScreen(
                                                  channel: single_channel,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child:  Container(
                                          // width: double.infinity,
                                          margin: const EdgeInsets
                                              .symmetric(
                                            horizontal: 5.0,
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10.0),
                                                child: Image.network(
                                                  single_channel.image
                                                      .toString(),
                                                  // for error handling
                                                  errorBuilder:
                                                      (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                        defaultChannelImage);
                                                  },

                                                  // height: double.infinity,
                                                  // width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      print(e);
                                      return Container();
                                    }
                                  },
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),);
                  } catch (e) {
                    print(e);
                    return Container();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
