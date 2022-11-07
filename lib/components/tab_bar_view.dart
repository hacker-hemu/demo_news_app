import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../screens/login.dart';
import '../services/news_category_service.dart';
import '../services/user_service.dart';

class CustomTabBarView extends StatefulWidget {
  const CustomTabBarView({Key? key}) : super(key: key);

  @override
  State<CustomTabBarView> createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView> {
  // save category
  List<dynamic> _categoryList = [];

  int userId = 0;
  bool _loading = true;

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

  // init state
  @override
  void initState() {
    print('=========== category retrieve function called ==============');
    retriveCategory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categoryList.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: _categoryList.map(
              (category) {
                return Builder(
                  builder: (BuildContext context) {
                    try {
                      return InkWell(
                        onTap: () {
                          print('category Carousel Container pressed');
                        },
                        child: Text(category.name),
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
        body: TabBarView(
          children: _categoryList.map(
            (category) {
              return Builder(
                builder: (BuildContext context) {
                  try {
                    return InkWell(
                      onTap: () {
                        print('category Carousel Container pressed');
                      },
                      child: Text(category.name),
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
    );
  }
}
