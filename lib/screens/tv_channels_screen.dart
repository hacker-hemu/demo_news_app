import 'package:badges/badges.dart';
import 'package:demo_news_app/models/channels.dart';
import 'package:demo_news_app/screens/tv_screen.dart';
import 'package:demo_news_app/screens/tv_shows_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../components/drawer.dart';
import '../components/likeCommentShare.dart';
import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/shows.dart';
import '../models/user.dart';
import '../notification/all_notifications_screen.dart';
import '../services/ads_service.dart';
import '../services/shows_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class TvChannelsScreen extends StatefulWidget {
  const TvChannelsScreen({Key? key, this.channel}) : super(key: key);
  final Channel? channel;

  @override
  State<TvChannelsScreen> createState() => _TvChannelsScreenState();
}

class _TvChannelsScreenState extends State<TvChannelsScreen> {
  // save ads
  List<dynamic> _adsList = [];

  // save news
  List<dynamic> _showsList = [];

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
  Future<void> retriveShows() async {
    userId = await getUserId();
    ApiResponse response = await getShows();

    print('user id for shows => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        _showsList = response.data as List<dynamic>;

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

  bool _fullScreen = false;

  @override
  Widget build(BuildContext context) {
    // getting news from main news screen
    Channel? channel = widget.channel;
    return SafeArea(
      child: Scaffold(
        // appbar
        appBar: _fullScreen
            ? null
            : AppBar(
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Image.asset(
                  shortLogoURL,
                  width: 150.0,
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                        // redirecting to home screen
                      },
                      icon: const Icon(Icons.notifications))
                ],
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => TvScreen()),
                        (Route<dynamic> route) => false);
                    // redirecting to home screen
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),

        // drawer
        drawer: const CustomDrawer(),

        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
          ),
          builder: (context, player) => Scaffold(
            body: RefreshIndicator(
              onRefresh: () {
                return retriveShows();
              },
              child: Column(
                children: [
                  player,
                  SizedBox(
                    height: 5.0,
                  ),

                  // channel name and category
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${channel?.name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        // category badge
                        Badge(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          animationType: BadgeAnimationType.fade,
                          shape: BadgeShape.square,
                          borderRadius: BorderRadius.circular(4),
                          badgeColor: Theme.of(context).primaryColor,
                          badgeContent: Text(
                            ' ${channel?.categoryName.toString()} ',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),

                  // channel title
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '${channel?.title}',
                      softWrap: false,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  // like share tile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        icon: Icons.share,
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
                      margin: EdgeInsets.all(2.5),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 16 / 8.5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                        itemCount: _showsList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          Shows shows = _showsList[index];

                          return Container(
                            // width: double.infinity,
                            height: 150.0,
                            margin: const EdgeInsets.only(
                              left: 2.5,
                              right: 2.5,
                            ),
                            child: InkWell(
                              onTap: () {
                                controller
                                    .pause(); //TODO when go to another screen then pause video then go..
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                      // TODO: redirecting to user_screen
                                      // return Container();
                                      return TvShowsScreen(
                                        shows: shows,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7.0),
                                    child: Image.network(
                                      width: 180.0,
                                      height: 90.0,
                                      shows.image.toString(),
                                      // for error handling
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(defaultShowImage);
                                      },

                                      // height: double.infinity,
                                      // width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  shows.isLive == 1
                                      ? Positioned(
                                          right: 0,
                                          child: Badge(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            animationType:
                                                BadgeAnimationType.fade,
                                            shape: BadgeShape.square,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            badgeContent: const Text(
                                              'Live',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // init state
  @override
  void initState() {
    super.initState();

    retriveShows();

    String? url;
    url = YoutubePlayer.convertUrlToId('${widget.channel?.videoLink}');

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
    )..addListener(listener);

    // portrait and landscape both mode is allow in this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // disposing speaking
  @override
  void dispose() {
    // when got to another screen then only portrait mode is on
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    controller.pause();
    controller.dispose();
    super.dispose();
  }

  // this code for => when full screen video then hide appBar
  void listener() {
    setState(() {
      _fullScreen = controller.value.isFullScreen;
    });
  }
}
