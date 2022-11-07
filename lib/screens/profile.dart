import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_news_app/models/api_response.dart';
import 'package:demo_news_app/screens/show_single_news.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';
import '../models/news.dart';
import '../models/user.dart';
import '../services/news_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;

  //image picker
  File? _imageFile;
  final _picker = ImagePicker();

  // save states
  List<dynamic> _statesList = [];

  // save district
  List<dynamic> _districtList = [];

  // save district
  List<dynamic> _userNewsList = [];

  // state dropdown default value
  var stateDropdownValue;

  // district dropdown default value
  var districtDropdownValue;

  // text field controller
  TextEditingController nameController = TextEditingController();

  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // get image function
  Future getImage() async {
    //yaha per mene pickImage ka use kiya hai bulki tutorial me getImage ka use kiya hai
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // get user details
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        nameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );

      debugPrint(
          '========= Update User ====== ${response.error} ==== Error ========');
    }
  }

  // getting all user News
  Future<void> retriveUserNews() async {
    // userId = await getUserId();
    ApiResponse response = await getUserNews();

    // print('user id is => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting login user news data');

        _userNewsList = response.data as List<dynamic>;

        loading = loading ? !loading : loading;
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

  // getting all state
  Future<void> retriveState() async {
    // userId = await getUserId();
    ApiResponse response = await getState();

    // print('user id is => $userId');

    // if no error so get all news in newsList[]
    if (response.error == null) {
      setState(() {
        debugPrint('getting news data');

        _statesList = response.data as List<dynamic>;

        loading = loading ? !loading : loading;
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

  // getting all state
  Future<void> retriveDistrict() async {
    ApiResponse response = await getDistrict(29);

    // if no error so get all district
    if (response.error == null) {
      setState(() {
        debugPrint('getting district data');

        _districtList = response.data as List<dynamic>;

        loading = loading ? !loading : loading;
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

  void updateProfile() async {
    String? image = _imageFile != null ? getStringImage(_imageFile) : null;
    debugPrint('image name is => $image');

    ApiResponse response =
        await updateUser(nameController.text, getStringImage(_imageFile));
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.data}'),
        ),
      );
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    getUser();
    debugPrint('========= getUser Function called ========');

    retriveState();
    debugPrint('========= getState Function called ========');

    retriveDistrict();
    debugPrint('========= getDistrict Function called ========');

    retriveUserNews();
    debugPrint('========= getUserNews Function called ========');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text('Edit Profile')),
              Tab(icon: Text('Your Posts')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // profile edite section
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: ListView(
                      children: [
                        Center(
                          child: GestureDetector(
                            child: Container(
                              width: 110.0,
                              height: 110.0,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(60.0),
                                image: _imageFile == null
                                    ? user?.image != null
                                        ? DecorationImage(
                                            image:
                                                NetworkImage('${user!.image}'),
                                            fit: BoxFit.cover,
                                          )
                                        : null
                                    : DecorationImage(
                                        image: FileImage(
                                          _imageFile ?? File(''),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            onTap: () {
                              getImage();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Form(
                          key: formKey,
                          child: TextFormField(
                            decoration: kInputDecoration('Name'),
                            controller: nameController,
                            validator: (val) =>
                                val!.isEmpty ? 'Invalid Name' : null,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        // news submit button
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                                updateProfile();
                              });

                              // updating profile
                              // return updateProfile();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue,
                            ),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            // address part
            // loading
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : Padding(
            //         padding: const EdgeInsets.only(
            //           top: 40.0,
            //           left: 40.0,
            //           right: 40.0,
            //         ),
            //         child: ListView(
            //           children: [
            //             // vertical space
            //             const SizedBox(
            //               height: 20.0,
            //             ),
            //
            //             // Form
            //             Form(
            //               key: formKey,
            //               child: Column(
            //                 children: [
            //                   // choose state
            //                   Container(
            //                     height: 50.0,
            //                     child: DropdownButtonFormField<String>(
            //                       hint: const Text('Select State'),
            //                       icon: const Icon(
            //                           Icons.keyboard_arrow_down_rounded),
            //                       elevation: 16,
            //                       style: const TextStyle(
            //                           color: Colors.black54, fontSize: 16.0),
            //                       decoration: const InputDecoration(
            //                         contentPadding:
            //                             EdgeInsets.symmetric(horizontal: 12.0),
            //                         border: OutlineInputBorder(
            //                           borderSide: BorderSide(
            //                             width: 1.0,
            //                             color: Colors.black,
            //                           ),
            //                         ),
            //                       ),
            //                       items: _statesList
            //                           .map<DropdownMenuItem<String>>(
            //                               (dynamic value) {
            //                         return DropdownMenuItem<String>(
            //                           value: value.id.toString(),
            //                           child: Text(value.name.toString()),
            //                         );
            //                       }).toList(),
            //                       onChanged: (value) {
            //                         // This is called when the user selects an item.
            //                         setState(() {
            //                           stateDropdownValue = value;
            //
            //                           var district = this
            //                               ._districtList
            //                               .where((setItem) =>
            //                                   setItem['state_id'].toString() ==
            //                                   value.toString())
            //                               .toList();
            //
            //                           print(stateDropdownValue);
            //                         });
            //
            //                         retriveDistrict(stateDropdownValue);
            //                       },
            //                       value: stateDropdownValue,
            //                     ),
            //                   ),
            //
            //                   // choose district
            //                   Container(
            //                     height: 50.0,
            //                     child: DropdownButtonFormField<String>(
            //                       hint: const Text('Select District'),
            //                       icon: const Icon(
            //                           Icons.keyboard_arrow_down_rounded),
            //                       elevation: 16,
            //                       style: const TextStyle(
            //                           color: Colors.black54, fontSize: 16.0),
            //                       decoration: const InputDecoration(
            //                         contentPadding:
            //                             EdgeInsets.symmetric(horizontal: 12.0),
            //                         border: OutlineInputBorder(
            //                           borderSide: BorderSide(
            //                             width: 1.0,
            //                             color: Colors.black,
            //                           ),
            //                         ),
            //                       ),
            //                       items: _districtList
            //                           .map<DropdownMenuItem<String>>(
            //                               (dynamic value) {
            //                         return DropdownMenuItem<String>(
            //                           value: value.id.toString(),
            //                           child: Text(value.name.toString()),
            //                         );
            //                       }).toList(),
            //                       onChanged: (value) {
            //                         // This is called when the user selects an item.
            //                         setState(() {
            //                           districtDropdownValue = value;
            //
            //                           print(districtDropdownValue);
            //                         });
            //                       },
            //                       value: districtDropdownValue,
            //                     ),
            //                   ),
            //
            //                   // vertical space
            //                   const SizedBox(
            //                     height: 20.0,
            //                   ),
            //
            //                   TextFormField(
            //                     decoration: kInputDecoration('State'),
            //                     controller: nameController,
            //                     validator: (val) =>
            //                         val!.isEmpty ? 'Invalid State' : null,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //
            //             // vertical space
            //             const SizedBox(
            //               height: 20.0,
            //             ),
            //
            //             // news submit button
            //             TextButton(
            //               onPressed: () {
            //                 if (formKey.currentState!.validate()) {
            //                   setState(() {
            //                     loading = true;
            //                     updateProfile();
            //                   });
            //
            //                   // updating profile
            //                   // return updateProfile();
            //                 }
            //               },
            //               style: ButtonStyle(
            //                 backgroundColor: MaterialStateColor.resolveWith(
            //                   (states) => Colors.blue,
            //                 ),
            //               ),
            //               child: const Text(
            //                 'Update',
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),

            // my post section
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // vertical space
                    const SizedBox(
                      height: 10.0,
                    ),

                    _userNewsList.isNotEmpty
                        ?
                        // main news showing Container
                        Column(
                            children: [
                              newsCategoryName(
                                  label: 'Total ${_userNewsList.length}'),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 0, 20.0),
                                color: Colors.black12,
                                child: Column(
                                  children: [
                                    if (loading)
                                      Container(
                                        height: 300.0,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    else
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _userNewsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          News userNews = _userNewsList[index];
                                          try {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                color: Colors.white,
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5.0,
                                                vertical: 5.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  userNews.newsImages == null
                                                      ?

                                                      // news single image
                                                      InkWell(
                                                          onTap: () {
                                                            userNews.approved ==
                                                                    '1'
                                                                ? Navigator
                                                                    .push(
                                                                    context,
                                                                    MaterialPageRoute<
                                                                        void>(
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        // TODO: redirecting to user_screen
                                                                        return ShowSingleNews(
                                                                          news:
                                                                              userNews,
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                : null;
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            5.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    // text section
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        // icon for approved or not
                                                                        IconButton(
                                                                          onPressed:
                                                                              () {},
                                                                          icon: FaIcon(userNews.approved == '1'
                                                                              ? FontAwesomeIcons.solidCircleCheck
                                                                              : FontAwesomeIcons.solidCircleXmark),
                                                                          iconSize:
                                                                              20.0,
                                                                          color: userNews.approved == '1'
                                                                              ? Colors.green
                                                                              : Colors.red,
                                                                        ),

                                                                        // news title
                                                                        Container(
                                                                          width:
                                                                              210.0,
                                                                          height:
                                                                              40.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10.0,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            '${userNews.title}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                2,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.black87,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    // image section
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                      child: Image
                                                                          .network(
                                                                        '${userNews.image}',
                                                                        height:
                                                                            80.0,
                                                                        width:
                                                                            130.0,
                                                                        fit: BoxFit
                                                                            .cover,

                                                                        // for error handling
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          print(
                                                                              error);

                                                                          // when network image does not load proper so show local image
                                                                          // return Image.asset(
                                                                          //     'assets/images/news_default_image.jpg');

                                                                          return const SizedBox(
                                                                            height:
                                                                                230.0,
                                                                            child:
                                                                                Center(child: CircularProgressIndicator()),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      :
                                                      // news multiple image
                                                      InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  // TODO: redirecting to user_screen
                                                                  return ShowSingleNews(
                                                                    news:
                                                                        userNews,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              // text section
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  // icon for approved or not
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {},
                                                                    icon: FaIcon(userNews
                                                                                .approved ==
                                                                            '1'
                                                                        ? FontAwesomeIcons
                                                                            .solidCircleCheck
                                                                        : FontAwesomeIcons
                                                                            .solidCircleXmark),
                                                                    iconSize:
                                                                        20.0,
                                                                    color: userNews
                                                                                .approved ==
                                                                            '1'
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red,
                                                                  ),

                                                                  // news title
                                                                  Container(
                                                                    width:
                                                                        210.0,
                                                                    height:
                                                                        40.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                    ),
                                                                    child: Text(
                                                                      '${userNews.title}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              // image section
                                                              Container(
                                                                width: 140.0,
                                                                child:
                                                                    CarouselSlider(
                                                                  options:
                                                                      CarouselOptions(
                                                                    height:
                                                                        90.0,
                                                                    viewportFraction:
                                                                        1,
                                                                    autoPlay:
                                                                        true,
                                                                  ),
                                                                  // TODO: change the variable name news to ad when adding advertisment api

                                                                  items: userNews
                                                                              .newsImages ==
                                                                          null
                                                                      ? [
                                                                          Image.asset(
                                                                              'assets/images/popular.png'),
                                                                        ]
                                                                      : userNews
                                                                          .newsImages
                                                                          ?.map(
                                                                            (imageUrl) =>
                                                                                Card(
                                                                              margin: const EdgeInsets.symmetric(
                                                                                horizontal: 5.0,
                                                                                vertical: 5.0,
                                                                              ),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                              ),
                                                                              elevation: 1.0,
                                                                              child: Stack(
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                                    child: Image.network(
                                                                                      '${imageUrl}',

                                                                                      height: 90.0,
                                                                                      width: 130.0,
                                                                                      fit: BoxFit.cover,

                                                                                      // for error handling
                                                                                      errorBuilder: (context, error, stackTrace) {
                                                                                        print(error);

                                                                                        // when network image does not load proper so show local image
                                                                                        // return Image.asset(
                                                                                        //     'assets/images/news_default_image.jpg');

                                                                                        return const SizedBox(
                                                                                          height: 230.0,
                                                                                          child: Center(child: CircularProgressIndicator()),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                ),
                                                              ),
                                                            ],
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

                                    // Container(
                                    //     padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    //     child: Row(
                                    //       mainAxisAlignment: MainAxisAlignment.center,
                                    //       children: [
                                    //         ElevatedButton(
                                    //             onPressed: () {
                                    //               debugPrint(
                                    //                   'Show more button pressed and redirecting to category page');
                                    //
                                    //               Navigator.push(context,
                                    //                   MaterialPageRoute<void>(
                                    //                 builder: (BuildContext context) {
                                    //                   // redirecting to user_screen
                                    //                   return Category(
                                    //                       Query: 'Technology');
                                    //                 },
                                    //               ));
                                    //             },
                                    //             child: const Text('SHOW MORE'))
                                    //       ],
                                    //     )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: 200.0,
                            height: MediaQuery.of(context).size.height - 250.0,
                            child: const Center(
                              child: Text('No News Found'),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
