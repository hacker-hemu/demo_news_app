import 'dart:io';

import 'package:demo_news_app/models/api_response.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';
import '../services/news_category_service.dart';
import '../services/news_service.dart';
import '../services/user_service.dart';
import 'login.dart';

class NewsCreateScreen extends StatefulWidget {
  const NewsCreateScreen({Key? key}) : super(key: key);

  @override
  State<NewsCreateScreen> createState() => _NewsCreateScreenState();
}

class _NewsCreateScreenState extends State<NewsCreateScreen> {
  // save category
  List<dynamic> _categoryList = [];

// creating controller for text fields
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // text field controller
  TextEditingController titleController = TextEditingController(),
      newsDescController = TextEditingController();

  // GlobalKey<FlutterSummernoteState> keyEditor = GlobalKey();

  // loading false
  bool _loading = false;

  //image picker
  File? _imageFile;
  final _picker = ImagePicker();
  int userId = 0;

  // for the news location
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  // category dropdown default value
  var categoryDropdownValue;

  Future getImage() async {
    //TODO: yaha per mene pickImage ka use kiya hai bulki tutorial me getImage ka use kiya hai
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // create news function
  void _createNews() async {
    String? image = _imageFile != null ? getStringImage(_imageFile) : null;
    debugPrint('image name is => $image');
    ApiResponse response = await createNews(
      titleController.text,
      newsDescController.text,
      categoryDropdownValue,
      image.toString(),
    );

    // final value = keyEditor.currentState?.getText();


    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('${response.error}'),
      //   ),
      // );

      debugPrint(
          '========= Create News ====== ${response.error} ==== Error ========');
    }
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('category retrieve function called');
    retriveCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create News'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                // select image and selected image view
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: _imageFile == null
                        ? null
                        : DecorationImage(
                            image: FileImage(
                              _imageFile ?? File(''),
                            ),
                            fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        debugPrint('Selecting News Image');
                        getImage();
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Colors.black38,
                        size: 50.0,
                      ),
                    ),
                  ),
                ),

                // input field form
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // vertical space
                            const SizedBox(
                              height: 10.0,
                            ),

                            // vertical space
                            const SizedBox(
                              height: 10.0,
                            ),

                            // vertical space
                            const SizedBox(
                              height: 10.0,
                            ),

                            // choose category
                            Container(
                              height: 50.0,
                              child: DropdownButtonFormField<String>(
                                hint: const Text('Select Category'),
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 16.0),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                items: _categoryList
                                    .map<DropdownMenuItem<String>>(
                                        (dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(value.name.toString()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    categoryDropdownValue = value;

                                    print(categoryDropdownValue);
                                  });
                                },
                                value: categoryDropdownValue,
                              ),
                            ),

                            // vertical space
                            const SizedBox(
                              height: 10.0,
                            ),

                            // title
                            TextFormField(
                              controller: titleController,
                              validator: (val) => val!.isEmpty
                                  ? 'News Title Is Required'
                                  : null,
                              decoration: kNewsInputDecoration('Add Title'),
                            ),

                            // vertical space
                            const SizedBox(
                              height: 10.0,
                            ),

                            // news description
                            TextFormField(
                              controller: newsDescController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              validator: (val) => val!.isEmpty
                                  ? 'News Description Is Required'
                                  : null,
                              decoration: const InputDecoration(
                                hintText: 'Add News Description',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                            ),

                            // vertical space
                            const SizedBox(
                              height: 10.0,
                            ),

                            // summerNote for news content
                            // FlutterSummernote(
                            //   value: keyEditor.currentState?.text,
                            //   hint: "Add News Content",
                            //   key: keyEditor,
                            //   height: 300.0,
                            //   hasAttachment: true,
                            //   customToolbar: """
                            //         [
                            //           ['style', ['bold', 'italic', 'underline', 'clear']],
                            //           ['font', ['strikethrough', 'superscript', 'subscript']],
                            //           ['insert', ['link', 'table', 'hr']]
                            //         ]
                            //       """,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // submit button
                Container(
                  width: 250.0,
                  margin: const EdgeInsets.symmetric(horizontal: 50.0),
                  child:
                      // news submit button
                      TextButton(
                    onPressed: () {
                      debugPrint(
                          '============ create news button pressed ============');
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = !_loading;
                          _createNews();
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(15.0)),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
