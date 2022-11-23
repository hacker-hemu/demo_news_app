import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/epaper.dart';
import '../models/user.dart';
import '../services/epaper_service.dart';
import '../services/user_service.dart';
import 'epaper_view_screen.dart';
import 'login.dart';

class EpaperSreen extends StatefulWidget {
  const EpaperSreen({Key? key}) : super(key: key);

  @override
  State<EpaperSreen> createState() => _EpaperSreenState();
}

class _EpaperSreenState extends State<EpaperSreen> {
  // save epapers
  List<dynamic> _epaperList = [];

  int userId = 0;
  bool _loading = true;
  User? user;

  // getting all news
  Future<void> _retriveEpapers() async {
    userId = await getUserId();
    ApiResponse response = await getEpapers();

    print('user id is => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting news data');

        _epaperList = response.data as List<dynamic>;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // epaper function calling
    _retriveEpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Papers'),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _epaperList.length,
              itemBuilder: (context, index) {
                Epaper epaper = _epaperList[index];

                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EpaperViewScreen(
                        url: epaper.image,
                        name: epaper.name,
                        date: epaper.date,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Colors.black45,
                        ),
                        onPressed: () {},
                      ),
                      Text('${epaper.name}'),
                      Text('${epaper.date}'),
                    ],
                  ),
                );
              }),
    );
  }
}
