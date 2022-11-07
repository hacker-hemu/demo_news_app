import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget Advertisement({required bool loading, List? list}) {
  return InkWell(
    onTap: () {
      debugPrint('redirect to link');
    },
    child: loading
        ? Container(
            height: 200.0,
            child: const Center(child: CircularProgressIndicator()))
        : CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              viewportFraction: 1,
              autoPlay: true,
            ),
            // TODO: change the variable name news to ad when adding advertisment api
            items: list?.map(
              (ad) {
                return Builder(
                  builder: (BuildContext context) {
                    try {
                      return InkWell(
                        onTap: () async {
                          var adLink = Uri.parse(ad.link);
                          var mobileNumber = ad.mobileNumber != null
                              ? Uri.parse('tel://' + ad.mobileNumber)
                              : Uri.parse('');

                          // if mobile number not null so click ad to calling
                          if (ad.mobileNumber != null) {
                            if (await canLaunchUrl(mobileNumber)) {
                              await launchUrl(mobileNumber);
                            } else {
                              throw 'Could not launch $mobileNumber';
                            }
                          }

                          // if ad link not null so open url
                          else if (adLink != null) {
                            if (await canLaunchUrl(adLink)) {
                              await launchUrl(adLink);
                            } else {
                              throw 'Could not launch $adLink';
                            }
                          }
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
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    ad.image.toString(),
                                    // for error handling
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/default_ad_image.webp',
                                      );
                                    },

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
                                    child: Center(
                                      child: Text(
                                        ad.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
