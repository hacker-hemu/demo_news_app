import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/screens/show_single_news.dart';
import 'package:demo_news_app/services/news_service.dart';
import 'package:demo_news_app/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../components/ads.dart';
import '../components/breaking_text_slider.dart';
import '../components/drawer.dart';
import '../components/likeCommentShare.dart';
import '../components/main_news_post_title.dart';
import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/news.dart';
import '../models/user.dart';
import '../notification/all_notifications_screen.dart';
import '../notification/local_notification_service.dart';
import '../services/ads_service.dart';
import '../services/news_category_service.dart';
import 'demo.dart';
import 'login.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // save news
  List<dynamic> _newsList = [];

  // save category
  List<dynamic> _categoryList = [];

  // save ads
  List<dynamic> _adsList = [];

  // save ads
  List<dynamic> newsImages = [];

  // save news images
  List<dynamic> _newsImagesList = [];

  // null breaking news
  List<dynamic> nullBreakingNews = ['Breaking News', 'Breaking News'];

  int userId = 0;
  bool _loading = true;
  User? user;

  // news theme
  int newsTheme = 1;

  // getting all news
  Future<void> retriveNews() async {
    userId = await getUserId();
    ApiResponse response = await getNews();

    print('user id is => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting news data');

        _newsList = response.data as List<dynamic>;

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

  // getting all category
  Future<void> retriveCategory() async {
    userId = await getUserId();
    ApiResponse response = await getNewsCategoryDetail();

    print('user id is for category => $userId');

    // if no error so get all news category in categoryList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting news category data');
        _categoryList = response.data as List<dynamic>;
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

  // getting all news images
  Future<void> retriveNewsIamges() async {
    userId = await getUserId();
    ApiResponse response = await getNews();

    print('user id is for news images => $userId');

    // if no error so get all news images in _newsImagesList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting news images data');
        _newsImagesList = response.data as List<dynamic>;
        ;
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

  // getting all ads
  Future<void> retriveAds() async {
    userId = await getUserId();
    ApiResponse response = await getAdsDetail();

    print('user id is for ads => $userId');

    // if no error so get all ads in _adsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting ads data');
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

  // news like and dislike function
  void _handleNewsLikeAndDislike(int newsId) async {
    ApiResponse response = await likeUnLikeNews(newsId);

    if (response.error == null) {
      retriveNews();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    debugPrint('=========== news retrieve function called ==============');
    retriveNews();

    debugPrint('=========== category retrieve function called ==============');
    retriveCategory();

    debugPrint('=========== top ads retrieve function called ==============');
    retriveAds();

    debugPrint(
        '=========== news images retrieve function called ==============');
    retriveNewsIamges();

    debugPrint('=========== push notification function  ==============');

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print(
            "////*******FirebaseMessaging.instance.getInitialMessage******/////");
        if (message != null) {
          print("New Notification");
          if (message.data['_id'] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DemoScreen(
                  id: message.data['_id'],
                ),
              ),
            );
          }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print(
            "||||||||||||**************FirebaseMessaging.onMessageOpenedApp.listen*************||||||||||||");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          shortLogoURL,
          width: 150.0,
        ),
        actions: [
          // notification
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
                // redirecting to home screen
              },
              icon: const Icon(Icons.notifications)),

          // theme change
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Choose News Theme'),
                          Column(
                            children: [
                              // horizontal type news view
                              ElevatedButton(
                                child: const Icon(
                                    Icons.panorama_horizontal_select_rounded),
                                onPressed: () {
                                  setState(() {
                                    newsTheme = 1;
                                  });
                                  Navigator.pop(context);
                                },
                              ),

                              // square type news tile
                              ElevatedButton(
                                child: const Icon(Icons.square),
                                onPressed: () {
                                  setState(() {
                                    newsTheme = 2;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.dashboard_customize_rounded),
          ),
        ],
      ),

      // drawer TODO: Create a news page for drawer
      drawer: CustomDrawer(),

      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return retriveNews();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // News Ticker
                    BuildAnimatedText(
                      startEndWith: '*',
                      text: _newsList.isNotEmpty
                          ? _newsList[0].breakingNewsTitle
                          : nullBreakingNews,
                      textBgColor: Theme.of(context).primaryColor,
                    ),

                    // vertical space
                    const SizedBox(
                      height: 2.5,
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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

                    // vertical space
                    const SizedBox(
                      height: 0.0,
                    ),

                    // Category TODO: Category commented now
                    /*
                    _categoryList.length > 0
                        ? Column(
                            children: [
                              // category title
                              newsCategoryName(
                                label: 'Categories',
                                verticalLineColor:
                                    Theme.of(context).primaryColor,
                              ),

                              // vertical space
                              const SizedBox(
                                height: 10.0,
                              ),

                              // all category in slider view
                              Category(
                                loading: _loading,
                                list: _categoryList,
                              ),
                            ],
                          )
                        : Container(
                            height: 100.0,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),

*/

                    // main news showing Container
                    newsTheme == 1
                        ? Container(
                            child: Column(
                              children: [
                                // vertical space
                                const SizedBox(
                                  height: 10.0,
                                ),

                                _newsList.isNotEmpty
                                    ?
                                    // news showing Container
                                    Column(
                                        children: [
                                          newsCategoryName(
                                              label: 'Latest News',
                                              verticalLineColor:
                                                  Theme.of(context)
                                                      .primaryColor),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 5.0, 0, 20.0),
                                            color: Colors.black12,
                                            child: Column(
                                              children: [
                                                if (_loading)
                                                  Container(
                                                    height: 300.0,
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  )
                                                else
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: _newsList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      News news =
                                                          _newsList[index];
                                                      try {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              5.0,
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 5.0,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // news multiple image
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute<
                                                                        void>(
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        // TODO: redirecting to single news screen
                                                                        return ShowSingleNews(
                                                                          news:
                                                                              news,
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    // image section
                                                                    Container(
                                                                      width:
                                                                          140.0,
                                                                      height:
                                                                          78.75,
                                                                      child:
                                                                          CarouselSlider(
                                                                        options:
                                                                            CarouselOptions(
                                                                          height:
                                                                              78.75,
                                                                          viewportFraction:
                                                                              1,
                                                                          autoPlay:
                                                                              false,
                                                                        ),
                                                                        // TODO: change the variable name news to ad when adding advertisement api

                                                                        items: news.newsImages ==
                                                                                null
                                                                            ? [
                                                                                Image.asset(defaultNewsImage),
                                                                              ]
                                                                            : news.newsImages
                                                                                ?.map(
                                                                                  (imageUrl) => Card(
                                                                                    margin: const EdgeInsets.symmetric(
                                                                                      horizontal: 5.0,
                                                                                      vertical: 5.0,
                                                                                    ),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(5.0),
                                                                                    ),
                                                                                    elevation: 1.0,
                                                                                    child: Stack(
                                                                                      children: [
                                                                                        ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                                          child: Image.network(
                                                                                            '${imageUrl}',

                                                                                            width: 140.0,
                                                                                            height: 78.75,
                                                                                            fit: BoxFit.cover,

                                                                                            // for error handling
                                                                                            errorBuilder: (context, error, stackTrace) {
                                                                                              print(error);

                                                                                              // when network image does not load proper so show local image
                                                                                              return Image.asset(defaultNewsImage);

                                                                                              // return const SizedBox(
                                                                                              //
                                                                                              //   height: 230.0,
                                                                                              //   child: Center(child: CircularProgressIndicator()),
                                                                                              // );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                                .toList(),
                                                                      ),
                                                                    ),

                                                                    // text section
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        // category name
                                                                        Visibility(
                                                                          visible:
                                                                              false,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Theme.of(context).primaryColor,
                                                                              borderRadius: BorderRadius.circular(3.0),
                                                                            ),
                                                                            height:
                                                                                20.0,
                                                                            width:
                                                                                80.0,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                news.categoryName.toString(),
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        // news title
                                                                        Container(
                                                                          width:
                                                                              210.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10.0,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            '${news.title}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                3,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.black87,
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } catch (e) {
                                                        print(e);
                                                        return Container();
                                                      }
                                                    },
                                                  ),

                                                // Container(
                                                //     padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                                //     child: Row(
                                                //       mainAxisAlignment: MainAxisAlignment.center,
                                                //       children: [
                                                //         ElevatedButton(
                                                //             onPressed: () {
                                                //               debugPrint(
                                                //                   'Show more button pressed and redirecting to category page');
                                                //
                                                //               Navigator.push(context,
                                                //                   MaterialPageRoute<void>(
                                                //                 builder: (BuildContext context) {
                                                //                   // redirecting to user_screen
                                                //                   return Category(
                                                //                       Query: 'Technology');
                                                //                 },
                                                //               ));
                                                //             },
                                                //             child: const Text('SHOW MORE'))
                                                //       ],
                                                //     )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        width: 200.0,
                                        height:
                                            MediaQuery.of(context).size.height -
                                                250.0,
                                        child: const Center(
                                          child: Text('No News Found'),
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Container(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 20.0, 0, 20.0),
                            color: Colors.black12,
                            child: Column(
                              children: [
                                // news category name
                                newsCategoryName(
                                  label: 'Latest News',
                                  verticalLineColor:
                                      Theme.of(context).primaryColor,
                                ),

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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _newsList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      News news = _newsList[index];
                                      // print('hello');
                                      // print('news image ' +
                                      //     news.newsImages.toString());
                                      try {
                                        // print('news image ' +
                                        //     news.newsImages.toString());
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) {
                                                  // TODO: redirecting to user_screen
                                                  return ShowSingleNews(
                                                    news: news,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: Colors.white,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                              vertical: 5.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MainNewsPostTitle(
                                                  // userImage:
                                                  //     'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                                                  textColor: Theme.of(context)
                                                      .primaryColor,
                                                  creatorImage:
                                                      news.user?.image != null
                                                          ? news.creatorImage
                                                              .toString()
                                                          : 'null',

                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute<void>(
                                                    //     builder:
                                                    //         (BuildContext context) {
                                                    //       // TODO: redirecting to user_screen
                                                    //       return const Profile();
                                                    //     },
                                                    //   ),
                                                    // );
                                                    debugPrint(
                                                        'Redirected To UserProfileScreen Page');
                                                  },
                                                  creatorName:
                                                      news.creatorName ?? '',

                                                  //TODO add category name
                                                  category: news.districtName ??
                                                      news.stateName ??
                                                      '',

                                                  //TODO: add hour ago functionality
                                                  hourAgo: news.created_at ??
                                                      'some time ago',
                                                  // hourAgo: news.created_at,
                                                ),
                                                // news title text
                                                Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15.0),
                                                  child: Text(
                                                    news.title ??
                                                        'News Title Static',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),

                                                news.newsImages == null
                                                    ?
                                                    // news single image
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute<
                                                                void>(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                // TODO: redirecting to user_screen
                                                                return ShowSingleNews(
                                                                  news: news,
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: Card(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 5.0,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          elevation: 1.0,
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                                child: Image
                                                                    .network(
                                                                  '${news.image}',

                                                                  // for error handling
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    print(
                                                                        error);

                                                                    // when network image does not load proper so show local image
                                                                    // return Image.asset(
                                                                    //     'assets/images/news_default_image.jpg');

                                                                    return const SizedBox(
                                                                      height:
                                                                          230.0,
                                                                      child: Center(
                                                                          child:
                                                                              CircularProgressIndicator()),
                                                                    );
                                                                  },
                                                                  height: 200.0,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 0,
                                                                right: 0,
                                                                bottom: 0,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0),
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0),
                                                                        Colors
                                                                            .black,
                                                                      ],
                                                                      begin: Alignment
                                                                          .topCenter,
                                                                      end: Alignment
                                                                          .bottomCenter,
                                                                    ),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        15.0,
                                                                  ),
                                                                  child: Text(
                                                                    '${news.news_desc}',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    :
                                                    // news multiple image
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute<
                                                                void>(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                // TODO: redirecting to user_screen
                                                                return ShowSingleNews(
                                                                  news: news,
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: CarouselSlider(
                                                          options:
                                                              CarouselOptions(
                                                            height: 200.0,
                                                            viewportFraction: 1,
                                                            autoPlay: true,
                                                          ),
                                                          // TODO: change the variable name news to ad when adding advertisment api

                                                          items:
                                                              news.newsImages ==
                                                                      null
                                                                  ? [
                                                                      Image.asset(
                                                                          'assets/images/popular.png'),
                                                                    ]
                                                                  : news
                                                                      .newsImages
                                                                      ?.map(
                                                                        (imageUrl) =>
                                                                            Card(
                                                                          margin:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                5.0,
                                                                            vertical:
                                                                                5.0,
                                                                          ),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                          ),
                                                                          elevation:
                                                                              1.0,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                child: Image.network(
                                                                                  '${imageUrl}',

                                                                                  // for error handling
                                                                                  errorBuilder: (context, error, stackTrace) {
                                                                                    print(error);

                                                                                    // when network image does not load proper so show local image
                                                                                    // return Image.asset(
                                                                                    //     'assets/images/news_default_image.jpg');

                                                                                    return const SizedBox(
                                                                                      height: 230.0,
                                                                                      child: Center(child: CircularProgressIndicator()),
                                                                                    );
                                                                                  },
                                                                                  height: 200.0,
                                                                                  width: double.infinity,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
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
                                                                                    child: Text(
                                                                                      '${news.news_desc}',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxLines: 2,
                                                                                      style: const TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                        ),
                                                      ),

                                                // like comment share section
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15.0,
                                                    vertical: 10.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      //like
                                                      likeShareComment(
                                                          label:
                                                              'Like ${news.likesCount ?? 0}',
                                                          icon: news.selfLiked ==
                                                                  true
                                                              ? FontAwesomeIcons
                                                                  .solidHeart
                                                              : FontAwesomeIcons
                                                                  .heart,
                                                          iconColor:
                                                              news.selfLiked ==
                                                                      true
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black45,
                                                          onPressed: () {
                                                            print(
                                                                'Like And Dislike');

                                                            _handleNewsLikeAndDislike(
                                                                news.id ?? 0);
                                                          }),
                                                      //comment
                                                      likeShareComment(
                                                          label: 'Comment',
                                                          icon: FontAwesomeIcons
                                                              .comment,
                                                          //TODO: I using theme primary color of the app
                                                          iconColor:
                                                              Colors.black38,
                                                          onPressed: () {
                                                            debugPrint(
                                                                'Do comment functionality');
                                                          }),
                                                      //share
                                                      likeShareComment(
                                                        label: 'Share',
                                                        icon: FontAwesomeIcons
                                                            .share,
                                                        onPressed: () {
                                                          Share.share(
                                                              '${news.title}\n\n\nन्यूज़ के लिए आज ही ऐप इंस्टॉल करें।\n\n$playStoreAppLink\n\n\nसंपर्क करें: $clientMobileNumber\nEmail: $clientEmail\n\n\n',
                                                              subject:
                                                                  'Look what I made!');
                                                        },
                                                      ),
                                                    ],
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
                                  ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
