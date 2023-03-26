import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';

import '../components/ads.dart';
import '../components/likeCommentShare.dart';
import '../components/main_news_post_title.dart';
import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/news.dart';
import '../services/ads_service.dart';
import '../services/news_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class ShowSingleNews extends StatefulWidget {
  const ShowSingleNews({Key? key, required this.news}) : super(key: key);
  final News news;

  @override
  State<ShowSingleNews> createState() => _ShowSingleNewsState();
}

class _ShowSingleNewsState extends State<ShowSingleNews> {
  // save news
  List<dynamic> _newsList = [];

  // save category
  List<dynamic> _categoryList = [];

  // save ads
  List<dynamic> _adsList = [];

  // save ads
  List<dynamic> newsImages = [];

  int userId = 0;
  bool _loading = true;

  // random number getting for news bottom advertisement
  final _random = Random();

  // check isSpeaking or not for  text to speech
  bool isSpeaking = false;

  // for change html tag from sring
  RegExp regExp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

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
                MaterialPageRoute(builder: (context) => const Login()),
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

    debugPrint('user id is for ads => $userId');

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

  // stop speaking
  stopSpeaking() async {
    await flutterTts.stop();
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

  // for text to speech
  final FlutterTts flutterTts = FlutterTts();

  // speak function for text to speech
  speak(String text) async {
    await flutterTts.setLanguage('hi-IN');
    await flutterTts.setPitch(1); //0.5 to 1.5
    await flutterTts.speak(text);
  }

  // init state
  @override
  void initState() {
    debugPrint('=========== news retrieve function called ==============');
    retriveNews();

    debugPrint('=========== top ads retrieve function called ==============');
    retriveAds();

    debugPrint('=========== Stop Speaking  ==============');
    stopSpeaking();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getting news from main news screen
    News news = widget.news;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appName),
          actions: [
            //share
            likeShareComment(
                label: '',
                icon: Icons.share,
                iconColor: Colors.white,
                onPressed: () {
                  Share.share(
                    '${news.title}\n\n\n ${news.news_desc}\n\n\nन्यूज़ के लिए आज ही ऐप इंस्टॉल करें।\n\n$playStoreAppLink\n\n\nसंपर्क करें: $clientMobileNumber\nEmail: $clientEmail\n\n\n${news.newsImages![0]}',
                    subject: 'Look what I made!',
                  );
                },
                iconSize: 20.0),
          ],
        ),

        // floating action button text to speech TODO: hide text to speech with 1 == 2 condition
        floatingActionButton: 1 == 2
            ? FloatingActionButton(
                onPressed: () {
                  isSpeaking = !isSpeaking;

                  setState(() {
                    isSpeaking == true
                        ? speak(
                            '${news.title ?? ''}, ${news.news_desc ?? ''}, ${news.content != null ? news.content.toString().replaceAll(regExp, ' ') : ''}')
                        : stopSpeaking();
                  });
                },
                child: Icon(isSpeaking ? Icons.mic_off_sharp : Icons.mic_sharp),
              )
            : Container(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // vertical space
              const SizedBox(
                height: 5.0,
              ),

              // carousel for advertisement
              _adsList.isEmpty
                  ? const SizedBox()
                  : Advertisement(loading: _loading, list: _adsList),

              // vertical space
              const SizedBox(
                height: 20.0,
              ),

              // state and total views
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // state name
                    Text(
                      news.stateName ?? '',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // total views
                    // Container(
                    //   height: 40.0,
                    //   width: 80.0,
                    //   decoration: BoxDecoration(
                    //       color:
                    //           Theme.of(context).primaryColor.withOpacity(0.2),
                    //       borderRadius: BorderRadius.circular(25.0)),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Icon(
                    //         Icons.remove_red_eye_outlined,
                    //         color:
                    //             Theme.of(context).primaryColor.withOpacity(0.5),
                    //       ),
                    //       const Text(
                    //         '567',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 15.0),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),

              // news title
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Wrap(
                  children: [
                    Text(
                      news.title.toString(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // color: news.titleColor != null
                        //     ? Color(
                        //         int.parse(news.titleColor.toString()),
                        //       )
                        //     : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // district share like
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // district name
                    Text(
                      news.districtName ?? news.categoryName ?? '',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              MainNewsPostTitle(
                textColor: Theme.of(context).primaryColor,
                creatorName: news.creatorName ?? '',
                creatorImage: news.creatorImage ?? '',
                category: news.districtName ?? news.stateName ?? '',
                hourAgo: news.created_at,
              ),

              news.newsImages == null
                  ?
                  // news single image
                  InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute<void>(
                        //     builder: (BuildContext context) {
                        //       // TODO: redirecting to user_screen
                        //       return ShowSingleNews(
                        //         news: news,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 1.0,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                '${news.image}',
                                height: 230.0,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                // for error handling
                                errorBuilder: (context, error, stackTrace) {
                                  print(error);

                                  // when network image does not load proper so show local image
                                  // return Image.asset(
                                  //     'assets/images/news_default_image.jpg');

                                  return SizedBox(
                                    child: Image.asset(
                                      defaultNewsImage,
                                      height: 230.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  :
                  // news multiple image
                  InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute<void>(
                      //       builder: (BuildContext context) {
                      //         // TODO: redirecting to user_screen
                      //         return ShowSingleNews(
                      //           news: news,
                      //         );
                      //       },
                      //     ),
                      //   );
                      // },
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 200.0,
                          viewportFraction: 1,
                          autoPlay: true,
                        ),
                        // TODO: change the variable name news to ad when adding advertisment api

                        items: news.newsImages == null
                            ? [
                                Image.asset('assets/images/popular.png'),
                              ]
                            : news.newsImages
                                ?.map(
                                  (imageUrl) => Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 5.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 1.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.network(
                                            '${imageUrl}',

                                            // for error handling
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              print(error);

                                              // when network image does not load proper so show local image
                                              // return Image.asset(
                                              //     'assets/images/news_default_image.jpg');

                                              return const SizedBox(
                                                height: 230.0,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            },
                                            height: 230.0,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),

              // vertical space
              const SizedBox(
                height: 20.0,
              ),

              // news short description
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Wrap(
                  children: [
                    Text(
                      news.news_desc.toString(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // color: news.titleColor != null
                        //     ? Color(
                        //         int.parse(news.titleColor.toString()),
                        //       )
                        //     : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // news main content description
              Html(
                data: news.content ?? '',
                style: {
                  "body": Style(
                    fontSize: FontSize(14.0),
                  ),
                },
              ),

              // vertical space
              const SizedBox(
                height: 20.0,
              ),

              // carousel for one random advertisement
              _adsList.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute<void>(
                      //       builder: (BuildContext context) {
                      //         // TODO: redirecting to user_screen
                      //         return ShowSingleNews(
                      //           news: news,
                      //         );
                      //       },
                      //     ),
                      //   );
                      // },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 1.0,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),

                              // getting random ad
                              child: Image.network(
                                '${_adsList[_random.nextInt(_adsList.length)].image}',

                                // for error handling
                                errorBuilder: (context, error, stackTrace) {
                                  print(error);

                                  // when network image does not load proper so show local image
                                  // return Image.asset(
                                  //     'assets/images/news_default_image.jpg');

                                  return const SizedBox(
                                    height: 230.0,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                },
                                height: 150.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              // related news
              Container(
                child: Column(
                  children: [
                    // vertical space
                    const SizedBox(
                      height: 10.0,
                    ),

                    _newsList.isNotEmpty
                        ?
                        // related news showing Container
                        Column(
                            children: [
                              newsCategoryName(
                                  label: 'Related News',
                                  verticalLineColor:
                                      Theme.of(context).primaryColor),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 0, 20.0),
                                color: Colors.black12,
                                child: Column(
                                  children: [
                                    if (_loading)
                                      Container(
                                        height: 300.0,
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
                                          News reletedNews = _newsList[index];
                                          try {
                                            return news.categoryName ==
                                                    reletedNews.categoryName
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5.0,
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    margin: const EdgeInsets
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
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  // TODO: redirecting to single news screen
                                                                  return ShowSingleNews(
                                                                    news: news,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              // image section
                                                              Container(
                                                                width: 140.0,
                                                                height: 78.75,
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

                                                                  items: reletedNews
                                                                              .newsImages ==
                                                                          null
                                                                      ? [
                                                                          Image.asset(
                                                                              defaultNewsImage),
                                                                        ]
                                                                      : reletedNews
                                                                          .newsImages
                                                                          ?.map(
                                                                            (imageUrl) =>
                                                                                Card(
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
                                                                                        return Image.asset(
                                                                                          defaultNewsImage,
                                                                                          width: 140.0,
                                                                                          height: 78.75,
                                                                                        );

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
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(3.0),
                                                                      ),
                                                                      height:
                                                                          20.0,
                                                                      width:
                                                                          80.0,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          news.categoryName
                                                                              .toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
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
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                    ),
                                                                    child: Text(
                                                                      '${news.title}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          3,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                  )
                                                : Container();
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
                            height: MediaQuery.of(context).size.height - 250.0,
                            child: const Center(
                              child: Text('No News Found'),
                            ),
                          ),
                  ],
                ),
              ),

              // download image for news
              // IconButton(
              //   // downlaod image
              //   icon: Icon(Icons.file_download),
              //   onPressed: () async {
              //     try {
              //       // Saved with this method.
              //       var imageId = await ImageDownloader.downloadImage(
              //           news.image.toString());
              //       if (imageId == null) {
              //         return;
              //       }
              //
              //       // Below is a method of obtaining saved image information.
              //       var fileName = await ImageDownloader.findName(imageId);
              //       var path = await ImageDownloader.findPath(imageId);
              //       var size = await ImageDownloader.findByteSize(imageId);
              //       var mimeType = await ImageDownloader.findMimeType(imageId);
              //
              //       // showing error in snackbar
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text('Image Downloaded'),
              //         ),
              //       );
              //     } on PlatformException catch (error) {
              //       print(error);
              //       // showing error in snackbar
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text("Image Not Download"),
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // disposing speaking
  @override
  void dispose() {
    speak('').dispose();
    super.dispose();
  }
}
