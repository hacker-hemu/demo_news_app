import 'package:demo_news_app/screens/epaper_screen.dart';
import 'package:demo_news_app/screens/news_screen.dart';
import 'package:demo_news_app/screens/profile.dart';
import 'package:demo_news_app/screens/webview_screens/webview_screen.dart';
import 'package:flutter/material.dart';

import 'news_create_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // for bottomBar
  int currentIndex = 0;
  bool loading = false;

  // all bottomBar screens
  static List<Widget> _widgetOptions = <Widget>[
    // main news screen
    NewsScreen(),

    // video screen
    // ChewieVideoPlayer(),
    // TvScreen(),

    WebViewScreen(),

    // create news
    NewsCreateScreen(),

    // E-paper screen
    EpaperSreen(),

    // profile screen
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      // appBar: AppBar(
      //   title: const Text('Popular Tv'),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           logout().then((value) => {
      //                 Navigator.of(context).pushAndRemoveUntil(
      //                     MaterialPageRoute(
      //                         builder: (context) => const Login()),
      //                     (route) => false)
      //               });
      //           debugPrint('Logout Success');
      //           // redirecting to home screen
      //         },
      //         icon: const Icon(Icons.exit_to_app_rounded))
      //   ],
      // ),

      // drawer
      // drawer: Drawer(
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           // vertical space
      //           const SizedBox(
      //             height: 20.0,
      //           ),
      //
      //           // app short Logo
      //           Image.asset(
      //             shortLogoURL,
      //             width: 200.0,
      //             height: 50.0,
      //           ),
      //
      //           // vertical space
      //           const SizedBox(
      //             height: 30.0,
      //           ),
      //
      //           // title name => setting
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: const [
      //               Text(
      //                 'Settings',
      //                 textAlign: TextAlign.start,
      //                 style: TextStyle(fontWeight: FontWeight.bold),
      //               ),
      //             ],
      //           ),
      //
      //           // vertical space
      //           const SizedBox(
      //             height: 20.0,
      //           ),
      //
      //           // profile
      //           customListTile(
      //             icon: Icons.account_circle_outlined,
      //             label: 'Profile',
      //             onTap: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (context) => const Profile(),
      //                 ),
      //               );
      //             },
      //           ),
      //
      //           // my post
      //           customListTile(
      //             icon: Icons.collections_bookmark_outlined,
      //             label: 'My Post',
      //           ),
      //
      //           // notification
      //           customListTile(
      //             icon: Icons.notifications_none_outlined,
      //             label: 'Notification',
      //           ),
      //
      //           // terms and condition
      //           customListTile(
      //             icon: Icons.event_note,
      //             label: 'Terms and Conditions',
      //             onTap: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (context) => const TermsAndConditions(),
      //                 ),
      //               );
      //             },
      //           ),
      //
      //           // share app
      //           customListTile(
      //             icon: Icons.share,
      //             label: 'Share With Friend',
      //           ),
      //
      //           // about
      //           customListTile(
      //             icon: Icons.info_outline_rounded,
      //             label: 'About',
      //             onTap: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (context) => const About(),
      //                 ),
      //               );
      //             },
      //           ),
      //
      //           // logout
      //           customListTile(
      //             icon: Icons.login_outlined,
      //             label: 'Logout',
      //             onTap: () {
      //               logout().then((value) => {
      //                     Navigator.of(context).pushAndRemoveUntil(
      //                         MaterialPageRoute(
      //                             builder: (context) => const Login()),
      //                         (route) => false)
      //                   });
      //               debugPrint('Logout Success');
      //               // redirecting to home screen
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      // floating action button for creating news

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Clicked to Create News Floating Action Button');

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewsCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        // notchMargin: 5,
        // elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            // home
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30.0,
              ),
              label: '',
            ),

            // Video
            BottomNavigationBarItem(
              icon: Icon(
                Icons.live_tv_rounded,
                size: 28.0,
              ),
              label: '',
            ),

            // blank
            BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper,
                color: Colors.transparent,
              ),
              label: '',
            ),

            // E-paper
            BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper,
                size: 25.0,
              ),
              label: '',
            ),

            // profile
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 25.0,
              ),
              label: '',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.black45,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
      body: _widgetOptions.elementAt(currentIndex),
    );
  }
}
