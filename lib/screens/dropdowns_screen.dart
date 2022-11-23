import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownsScreen extends StatefulWidget {
  const DropdownsScreen({Key? key}) : super(key: key);

  @override
  State<DropdownsScreen> createState() => _DropdownsScreenState();
}

class _DropdownsScreenState extends State<DropdownsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic DropDownList REST API'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(bottom: 100, top: 100),
            child: const Text(
              'KDTechs',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
          //======================================================== State

          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myState,
                        iconSize: 30,
                        icon: (null),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: const Text('Select State'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _myState = newValue!;
                            _getCitiesList();
                            print(_myState);
                          });
                        },
                        items: statesList?.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(item['name']),
                              );
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          //======================================================== City

          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myCity,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select City'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _myCity = newValue!;
                            print(_myCity);
                          });
                        },
                        items: citiesList?.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['name']),
                                value: item['id'].toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//=============================================================================== Api Calling here

//CALLING STATE API HERE
// Get State information by API
List? statesList;
String? _myState;

Uri stateInfoUrl = 'http://cleanions.bestweb.my/api/location/get_state' as Uri;
Future<String?> _getStateList() async {
  await http.post(stateInfoUrl, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  }, body: {
    "api_key": '25d55ad283aa400af464c76d713c07ad',
  }).then((response) {
    var data = json.decode(response.body);

//      print(data);
//     setState(() {
//       statesList = data['state'];
//     });
  });
}

// Get State information by API
List? citiesList;
String? _myCity;

Uri cityInfoUrl =
    'http://cleanions.bestweb.my/api/location/get_city_by_state_id' as Uri;
Future<String?> _getCitiesList() async {
  await http.post(cityInfoUrl, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  }, body: {
    "api_key": '25d55ad283aa400af464c76d713c07ad',
    "state_id": _myState,
  }).then((response) {
    var data = json.decode(response.body);

    // setState(() {
    //   citiesList = data['cities'];
    // });
  });
}
