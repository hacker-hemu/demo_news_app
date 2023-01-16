import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/api_response.dart';
import '../../models/tv_models/channels.dart';
import '../../models/user.dart';
import '../../services/tv_services/channels_service.dart';
import '../../services/user_service.dart';
import '../login.dart';
import 'tv_channels_screen.dart';

class AllChannels extends StatefulWidget {
  const AllChannels({Key? key}) : super(key: key);

  @override
  State<AllChannels> createState() => _AllChannelsState();
}

class _AllChannelsState extends State<AllChannels> {
  // save all channels
  List<dynamic> _channelsList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all news
  Future<void> retriveChannels() async {
    userId = await getUserId();
    ApiResponse response = await getChannels();

    print('user id for all channels => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting channel data');

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
    super.initState();

    debugPrint('=========== all channels retrieve function ==============');
    retriveChannels();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _channelsList.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      Channel channels = _channelsList[index];
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
                                      'Channels',
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
                                        ),
                                        // TODO: change the variable name news to ad when adding advertisement api
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
                                                          builder: (BuildContext
                                                              context) {
                                                            // TODO: redirecting to user_screen
                                                            // return Container();
                                                            return TvChannelsScreen(
                                                              channel:
                                                                  single_channel,
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
                                                              single_channel
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
