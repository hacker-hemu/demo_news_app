import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:demo_news_app/epaper_page.dart';
import 'package:demo_news_app/main_drawer.dart';

import 'read_news_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // got to another page on click bottom icons
  final _pages = [
    // this column for home (current page )
    Column(
      children: [
        // some space between appbar and slider
        const SizedBox(
          height: 30.0,
        ),

        // main page first slider
        CarouselSlider(
          items: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          options: CarouselOptions(
            autoPlay: true,
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            initialPage: 4,

            // height: 300.0,
          ),
        ),

        // some space
        const SizedBox(
          height: 30.0,
        ),

        // Popular Channels Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Popular Channels',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            // Show all channels button
            TextButton(
              onPressed: () {},
              child: const Icon(
                Icons.apps_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Popular Channels Images
        Wrap(
          runSpacing: 10.0,
          spacing: 10.0,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        // width: 150.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        // height: 100.0,
                        // width: 150.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        width: 150.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        width: 150.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // some space
        const SizedBox(
          height: 30.0,
        ),

        // Read News Channels Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Read News',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            // Show all channels button
            TextButton(
              onPressed: () {},
              child: const Icon(
                Icons.apps_outlined,
                color: Colors.white,
              ),
            )
          ],
        ),

        // Read news slider slider
        CarouselSlider(
          items: [
            Container(
              width: 70.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 70.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 70.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 70.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          options: CarouselOptions(
            autoPlay: false,
            autoPlayCurve: Curves.easeInOut,
            // enlargeCenterPage: true,
            viewportFraction: 0.25,
            initialPage: 4,
            height: 70.0,

            // height: 300.0,
          ),
        ),

        // some space
        const SizedBox(
          height: 30.0,
        ),

        // Live News Channels Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Live Channels',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            // Show all channels button
            TextButton(
              onPressed: () {},
              child: const Icon(
                Icons.apps_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Live News Channels Images
        Wrap(
          runSpacing: 10.0,
          spacing: 10.0,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        // width: 150.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        // height: 100.0,
                        // width: 150.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        width: 150.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2022/08/29/07/44/port-7418239_960_720.jpg',
                        width: 150.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // this is read news page widget
    const ReadNews(),

    // this is e-paper page widget
    const Epaper(),
  ];

  // this variable for bottom bar
  int _isBottomSelected = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: const MainDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'Demo News App',
          ),
        ),
        body: SingleChildScrollView(
          // calling Page List to goto another pages
          child: _pages[_isBottomSelected],
        ),

        // bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black12,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Read News',
              icon: Icon(Icons.local_library),
            ),
            BottomNavigationBarItem(
              label: 'E-paper',
              icon: Icon(Icons.newspaper),
            ),
          ],
          currentIndex: _isBottomSelected,
          onTap: (setValue) {
            setState(() {
              _isBottomSelected = setValue;
            });
          },
        ),
      ),
    );
  }
}
