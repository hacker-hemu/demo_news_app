import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/screens/tv_screens/tv_recommended_channels_screen.dart';
import 'package:demo_news_app/services/tv_services/recommended_channels_service.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/api_response.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../login.dart';

class RecommendedChannels extends StatefulWidget {
  const RecommendedChannels({Key? key}) : super(key: key);

  @override
  State<RecommendedChannels> createState() => _RecommendedChannelsState();
}

class _RecommendedChannelsState extends State<RecommendedChannels> {
  // save all channels
  List<dynamic> _recommendedChannelsList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all news
  Future<void> retrieveRecommendedChannels() async {
    userId = await getUserId();
    ApiResponse response = await getRecommendedChannels();

    debugPrint('user id for recommended channels => $userId');

    // if no error so get all rec.. channels
    if (response.error == null) {
      setState(() {
        debugPrint('getting recommended channel data');

        _recommendedChannelsList = response.data as List<dynamic>;

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

  // init state
  @override
  void initState() {
    super.initState();

    debugPrint(
        '=========== recommended channels retrieve function ==============');
    retrieveRecommendedChannels();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _recommendedChannelsList.isNotEmpty
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
                                      'Recommended',
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
                                    ? const SizedBox(
                                        height: 200.0,
                                        child: Center(
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
                                        items: _recommendedChannelsList.map(
                                          (recommendedChannel) {
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
                                                            return TvRecommendedChannelsScreen(
                                                              recommendedChannels:
                                                                  recommendedChannel,
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
                                                              recommendedChannel
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
