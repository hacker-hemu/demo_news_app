import 'package:flutter/material.dart';

import 'home_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          // profile image container
          Container(
            width: double.infinity,
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://png.pngitem.com/pimgs/s/130-1300400_user-hd-png-download.png',
                  ),
                ),
              ),
            ),
          ),

          // app name in drawer
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Demo News App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),

          // some space in height
          const SizedBox(
            height: 20.0,
          ),

          // horizontal line
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              color: Colors.white,
            ),
          ),
          // home page
          Container(
            child: ListTile(
              title: const Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: const Icon(
                Icons.home,
                color: Colors.white,
                size: 30.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
          ),

          // popular channels
          Container(
            child: const ListTile(
              title: Text(
                'Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),

          // news channels
          Container(
            child: const ListTile(
              title: Text(
                'News',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.newspaper,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),

          // bhakti channels
          Container(
            child: const ListTile(
              title: Text(
                'Bhakti',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.settings_suggest,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),

          // sports channels
          Container(
            child: const ListTile(
              title: Text(
                'Sports',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.sports_volleyball,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),

          // movies channels
          Container(
            child: const ListTile(
              title: Text(
                'Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.movie,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),

          // music channels
          Container(
            child: const ListTile(
              title: Text(
                'Musics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.music_note,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
