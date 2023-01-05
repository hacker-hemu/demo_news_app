import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

Widget Category({required bool loading, List? list}) {
  return SizedBox(
    child: loading
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
              viewportFraction: 0.33,
              // enableInfiniteScroll: false,
              autoPlay: true,
            ),
            // TODO: change the variable name news to ad when adding advertisment api
            items: list?.map(
              (category) {
                return Builder(
                  builder: (BuildContext context) {
                    try {
                      return InkWell(
                        onTap: () {
                          print('category Carousel Container pressed');
                        },
                        child: Container(
                          // width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  category.image.toString(),
                                  // for error handling
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(defaultCategoryImage);
                                  },

                                  // height: double.infinity,
                                  // width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // carousel title
                              // Positioned(
                              //   left: 0,
                              //   right: 0,
                              //   bottom: 0,
                              //   child: Container(
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //             BorderRadius.circular(15.0),
                              //         gradient: LinearGradient(
                              //           colors: [
                              //             Colors.black.withOpacity(0),
                              //             Colors.black,
                              //           ],
                              //           begin: Alignment.topCenter,
                              //           end: Alignment.bottomCenter,
                              //         ),
                              //       ),
                              //       padding: const EdgeInsets.symmetric(
                              //         horizontal: 10.0,
                              //         vertical: 15.0,
                              //       ),
                              //       child: Center(
                              //         child: Text(
                              //           category.name,
                              //           overflow: TextOverflow.ellipsis,
                              //           style: const TextStyle(
                              //             color: Colors.white,
                              //             fontSize: 15.0,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //       )),
                              // ),
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
  );
}
