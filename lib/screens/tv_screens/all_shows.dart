import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/models/shows.dart';
import 'package:demo_news_app/screens/tv_screens/tv_shows_screen.dart';
import 'package:demo_news_app/services/shows_service.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/api_response.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../login.dart';

class AllShows extends StatefulWidget {
  const AllShows({Key? key}) : super(key: key);

  @override
  State<AllShows> createState() => _AllShowsState();
}

class _AllShowsState extends State<AllShows> {
  // save all shows
  List<dynamic> _showsList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all shows
  Future<void> retriveShows() async {
    userId = await getUserId();
    ApiResponse response = await getShows();

    print('user id for all shows => $userId');

    // if no error so get all shows[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting shows data');

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

  // init state
  @override
  void initState() {
    super.initState();

    debugPrint('=========== all shows retrieve function ==============');
    retriveShows();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _showsList.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      Shows shows = _showsList[index];
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
                                margin: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  top: 20.0,
                                  bottom: 5.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Shows',
                                      style: TextStyle(
                                          color: kTextLightColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                      color: kTextLightColor,
                                    ),
                                  ],
                                ),
                              ),

                              // all shows in slider view
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
                                          height: 100.0,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 0.50,
                                          // enableInfiniteScroll: false,
                                          autoPlay: false,
                                          disableCenter: true,
                                          padEnds: false,
                                        ),
                                        // TODO: change the variable name news to ad when adding advertisement api
                                        items: _showsList.map(
                                          (single_show) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                try {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute<void>(
                                                          builder: (BuildContext
                                                              context) {
                                                            // TODO: redirecting to user_screen
                                                            // return Container();
                                                            return TvShowsScreen(
                                                              shows:
                                                                  single_show,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
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
                                                                    .circular(
                                                                        10.0),
                                                            child:
                                                                Image.network(
                                                              single_show.image
                                                                  .toString(),
                                                              height: 100.0,
                                                              // width: 100,
                                                              // for error handling
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Image
                                                                    .asset(
                                                                  defaultShowImage,
                                                                );
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
            )
          : SizedBox(
              height:
                  // MediaQuery.of(context).size.height - 350.0,
                  300.0,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
    } catch (e) {
      print(e);
      return Container();
    }
  }
}
