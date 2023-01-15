import 'package:demo_news_app/screens/tv_screens/all_channels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/ads.dart';
import '../../components/drawer.dart';
import '../../constants/constants.dart';
import '../../models/api_response.dart';
import '../../models/user.dart';
import '../../notification/all_notifications_screen.dart';
import '../../services/ads_service.dart';
import '../../services/channels_service.dart';
import '../../services/user_service.dart';
import '../chewie_video_player.dart';
import '../login.dart';
import 'all_shows.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({Key? key}) : super(key: key);

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  // save ads
  List<dynamic> _adsList = [];

  // save channels
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

    // portrait and landscape both mode is allow in this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appbar
        appBar: AppBar(
          // iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          iconTheme: const IconThemeData(color: kAppBarIconLightColor),
          backgroundColor: kBgAppBarColor,
          centerTitle: true,
          title: Image.asset(
            shortLogoURL,
            width: 150.0,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  logout().then((value) => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        ),
                      });
                  // redirecting to home screen
                },
                icon: const Icon(Icons.notifications))
          ],
        ),

        // drawer TODO: Create a news page for drawer
        drawer: CustomDrawer(),

        body: SingleChildScrollView(
          child: Container(
            color: kBgLightColor,
            child: Column(
              children: [
                ChewieVideoPlayer(),

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
                                        color: kTextLightColor,
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
                  const AllChannels(),

                // shows
                if (_loading)
                  Container(
                      // height:
                      //     // MediaQuery.of(context).size.height - 350.0,
                      //     300.0,
                      // child: const Center(
                      //   child: CircularProgressIndicator(),
                      // ),
                      )
                else
                  const AllShows(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // when got to another screen then only portrait mode is on
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
