import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/screens/tv_screens/tv_popular_channels_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/api_response.dart';
import '../../models/user.dart';
import '../../services/tv_services/popular_channels_service.dart';
import '../../services/user_service.dart';
import '../login.dart';

class PopularChannels extends StatefulWidget {
  const PopularChannels({Key? key}) : super(key: key);

  @override
  State<PopularChannels> createState() => _PopularChannelsState();
}

class _PopularChannelsState extends State<PopularChannels> {
  // save popular channels
  List<dynamic> _popularChannelsList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all popular channels
  Future<void> retrievePopularChannels() async {
    userId = await getUserId();
    ApiResponse response = await getPopularChannels();

    print('user id for popular channels => $userId');

    // if no error so get all popular channels
    if (response.error == null) {
      setState(() {
        debugPrint('getting popular channel data');

        _popularChannelsList = response.data as List<dynamic>;

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

    debugPrint('=========== popular channels retrieve function ==============');
    retrievePopularChannels();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _popularChannelsList.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      try {
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
                                      'Popular',
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
                                          height: 100.0,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 0.50,
                                          // enableInfiniteScroll: false,
                                          autoPlay: false,
                                          disableCenter: true,
                                          padEnds: false,
                                          enableInfiniteScroll: false,
                                        ),
                                        // TODO: change the variable name news to ad when adding advertisement api
                                        items: _popularChannelsList.map(
                                          (popularChannel) {
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
                                                            return TvPopularChannelsScreen(
                                                              popularChannels:
                                                                  popularChannel,
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
                                                              10.0,
                                                            ),
                                                            child:
                                                                Image.network(
                                                              popularChannel
                                                                  .image
                                                                  .toString(),
                                                              height: 100.0,
                                                              // for error handling
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
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
          : const SizedBox();
    } catch (e) {
      print(e);
      return Container();
    }
  }
}
