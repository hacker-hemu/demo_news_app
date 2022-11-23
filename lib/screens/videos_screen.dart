import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/screens/show_single_news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/news.dart';
import '../models/user.dart';
import '../services/news_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  // save news
  List<dynamic> _newsList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

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

  // List? vidoeIds = _newsList.tit

  // init state
  @override
  void initState() {
    super.initState();

    // news function calling
    retriveNews();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // itemCount: _newsList.length,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        News news = _newsList[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          // margin: const EdgeInsets.symmetric(
          //   horizontal: 5.0,
          //   vertical: 5.0,
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // news multiple image
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        // TODO: redirecting to user_screen
                        return ShowSingleNews(
                          news: news,
                        );
                      },
                    ),
                  );
                },
                child: CarouselSlider(
                  options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1,
                    autoPlay: false,
                  ),
                  // TODO: change the variable name news to ad when adding advertisement api

                  items: news.newsImages == null
                      ? [
                          //TODO: change image url popular.png to another
                          Image.asset('assets/images/popular.png'),
                        ]
                      : _newsList
                          .map(
                            (news) => Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    // borderRadius:
                                    // BorderRadius.circular(15.0),
                                    color: Colors.black,
                                  ),
                                  child: Image.network(
                                    '${news.image}',

                                    // for error handling
                                    errorBuilder: (context, error, stackTrace) {
                                      print(error);

                                      // when network image does not load proper so show local image
                                      return Image.asset(
                                          'assets/images/news_default_image.jpg');
                                    },
                                    // height: 230.0,
                                    height: double.maxFinite,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                // video section
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 200.0,
                                    child: Text('vidoe '),
                                  ),
                                ),

                                // left side title and description and right side userProfile, like, views and share
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 350,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // creator Name
                                          Text(
                                            '${news.creatorName}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10.0,
                                                  color: Colors.black,
                                                  offset: Offset(5.0, 5.0),
                                                ),
                                                Shadow(
                                                  color: Colors.blue,
                                                  blurRadius: 20.0,
                                                  offset: Offset(0.0, 2.0),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // vertical space
                                          const SizedBox(height: 20.0),

                                          // news title
                                          Container(
                                            width: 200.0,
                                            child: Text(
                                              '${news.title}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 10.0,
                                                    color: Colors.black,
                                                    offset: Offset(5.0, 5.0),
                                                  ),
                                                  Shadow(
                                                    color: Colors.blue,
                                                    blurRadius: 20.0,
                                                    offset: Offset(0.0, 2.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // vertical space
                                          const SizedBox(height: 10.0),

                                          // news description
                                          Container(
                                            width: 200.0,
                                            child: Text(
                                              '${news.news_desc}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 10.0,
                                                    color: Colors.black,
                                                    offset: Offset(5.0, 5.0),
                                                  ),
                                                  Shadow(
                                                    color: Colors.blue,
                                                    blurRadius: 20.0,
                                                    offset: Offset(0.0, 2.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // vertical space
                                          SizedBox(height: 10.0),
                                        ],
                                      ),

                                      // like view and share button in right side
                                      Column(
                                        children: [
                                          // creator Image
                                          InkWell(
                                            onTap: () {
                                              debugPrint(
                                                  'Redirect to User Profile page');
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: Image.network(
                                                '${news.creatorImage}',
                                                // for error handling
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  print(error);

                                                  // when network image does not load proper so show local image
                                                  return Image.asset(
                                                    'assets/images/defaultUserImage.png',
                                                    width: 45.0,
                                                    height: 45.0,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                                width: 45.0,
                                                height: 45.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          // likes
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.favorite,
                                              size: 30.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Text(
                                            '1.5k',
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.white,
                                            ),
                                          ),

                                          // views
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.remove_red_eye_rounded,
                                              size: 30.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Text(
                                            '10.5k',
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.white,
                                            ),
                                          ),

                                          // share
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.share,
                                              color: Colors.white,
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
                          .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
