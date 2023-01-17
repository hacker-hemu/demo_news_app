import 'package:badges/badges.dart';
import 'package:demo_news_app/screens/tv_screens/tv_screen.dart';
import 'package:demo_news_app/screens/tv_screens/tv_shows_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../components/ads.dart';
import '../../components/drawer.dart';
import '../../components/likeCommentShare.dart';
import '../../constants/constants.dart';
import '../../models/api_response.dart';
import '../../models/tv_models/popular_channels.dart';
import '../../models/tv_models/shows.dart';
import '../../models/user.dart';
import '../../notification/all_notifications_screen.dart';
import '../../services/ads_service.dart';
import '../../services/tv_services/shows_service.dart';
import '../../services/user_service.dart';
import '../login.dart';

class TvPopularChannelsScreen extends StatefulWidget {
  const TvPopularChannelsScreen({Key? key, this.popularChannels})
      : super(key: key);
  final PopularChannels? popularChannels;

  @override
  State<TvPopularChannelsScreen> createState() =>
      _TvPopularChannelsScreenState();
}

class _TvPopularChannelsScreenState extends State<TvPopularChannelsScreen> {
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
  bool _infoVisible = false;
  bool _isLinkCopied = false; //copy link
  bool _isLiked = false; //video like dummy

  @override
  Widget build(BuildContext context) {
    // getting news from main news screen
    PopularChannels? channel = widget.popularChannels;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgLightColor,
        // appbar
        appBar: _fullScreen
            ? null
            : AppBar(
                iconTheme: const IconThemeData(color: kAppBarIconLightColor),
                backgroundColor: kBgAppBarColor,
                centerTitle: true,
                title: Image.asset(
                  shortLogoWhiteURL,
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
            backgroundColor: kBgLightColor,
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

                  // like share tile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //info
                      likeShareComment(
                        label: '',
                        icon: Icons.info_outline,
                        iconColor: _infoVisible
                            ? Theme.of(context).primaryColor
                            : kIconLightColor,
                        onPressed: () {
                          return setState(() {
                            _infoVisible = !_infoVisible;
                          });
                        },
                        iconSize: 23.0,
                      ),
                      //like
                      likeShareComment(
                        label: '',
                        icon: _isLiked
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        iconColor: _isLiked
                            ? Theme.of(context).primaryColor
                            : kIconLightColor,
                        onPressed: () {
                          return setState(() {
                            _isLiked = !_isLiked;
                            if (_isLiked == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Thanks'),
                              ));
                            }
                          });
                        },
                        iconSize: 20.0,
                      ),

                      // link
                      likeShareComment(
                        label: '',
                        icon: FontAwesomeIcons.link,
                        iconColor: _isLinkCopied
                            ? Theme.of(context).primaryColor
                            : kIconLightColor,
                        onPressed: () {
                          Clipboard.setData(
                                  const ClipboardData(text: playStoreAppLink))
                              .then((value) {
                            setState(() {
                              _isLinkCopied = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Link Copied'),
                              ),
                            );
                          });
                        },
                        iconSize: 20.0,
                      ),
                      // share
                      likeShareComment(
                        label: '',
                        icon: Icons.share,
                        iconColor: kIconLightColor,
                        onPressed: () {
                          Share.share(
                            'न्यूज़ के लिए आज ही ऐप इंस्टॉल करें।\n\n$playStoreAppLink\n\n\nसंपर्क करें: $clientMobileNumber\nEmail: $clientEmail\n\n\n',
                            subject: 'Look what I made!',
                          );
                        },
                        iconSize: 20.0,
                      ),
                    ],
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
                            color: kTextLightColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
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
                  Visibility(
                    visible: _infoVisible,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${channel?.title}',
                        softWrap: false,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: kTextLightColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),

                  // vertical space
                  SizedBox(
                    height: 10.0,
                  ),

                  // carousel for advertisement
                  _adsList.isEmpty
                      ?
                      // static ad image TODO: replace with news image when test ad image is ready
                      Container()
                      : Advertisement(loading: _loading, list: _adsList),

                  // vertical space
                  SizedBox(
                    height: 10.0,
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

    retriveAds();

    String? url;
    url = YoutubePlayer.convertUrlToId('${widget.popularChannels?.videoLink}');

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
