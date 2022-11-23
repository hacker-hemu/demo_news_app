import 'package:demo_news_app/services/video_news_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../models/videoNews.dart';
import '../services/user_service.dart';
import 'login.dart';

class VideosNewsScreen extends StatefulWidget {
  const VideosNewsScreen({Key? key}) : super(key: key);

  @override
  State<VideosNewsScreen> createState() => _VideosNewsScreenState();
}

class _VideosNewsScreenState extends State<VideosNewsScreen> {
  // save news
  List<dynamic> _videoNewsList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all news
  Future<void> retriveVideoNews() async {
    userId = await getUserId();
    ApiResponse response = await getVideoNews();

    print('user id is for video news => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting video news data');

        _videoNewsList = response.data as List<dynamic>;

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

    // video news function calling
    retriveVideoNews();
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
          VideoNews videoNews = _videoNewsList[index];

          return Text('Hello');
        });
  }
}
