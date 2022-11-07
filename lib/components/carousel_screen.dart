import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselScreen extends StatefulWidget {
  final String? imgURL;
  const CarouselScreen({Key? key, this.imgURL}) : super(key: key);

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  // for image sources now for color
  List items = [
    'https://image.shutterstock.com/image-vector/breaking-news-background-world-global-260nw-719766118.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_oo4DFJs1Kfa6xJKUgwUdbHKXG43LsIAWWbyVebNhkl1dRaehlR9Qvt983jsIYkBWAic&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwgzoTTkBU32ujklum1MaQ3h3rLqBuoLpKRx9kZ-7Cr-CS4VMPN5SEAGF-oNUoeaE9n7E&usqp=CAU',
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint('redirect to link');
      },
      child: CarouselSlider(
        items: items.map((item) {
          return Builder(builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                print('Advertisement Carousel Container pressed');
              },
              child: Container(
                // width: double.infinity,
                child: Card(
                  elevation: 5.0,
                  semanticContainer: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          item,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),

                      // carousel title
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0),
                                  Colors.black,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 15.0,
                            ),
                            child: const Center(
                              child: Text(
                                'Carousel Title',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        }).toList(),
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          viewportFraction: 0.9,
        ),
      ),
    );
  }
}
