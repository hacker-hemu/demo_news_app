import 'dart:convert';
import 'dart:io';

import 'package:demo_news_app/constants/constants.dart';
import 'package:demo_news_app/models/api_response.dart';
import 'package:demo_news_app/models/news_district.dart';
import 'package:demo_news_app/models/news_state.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

// login user
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// register user
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// get user detail
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// update user
Future<ApiResponse> updateUser(String name, String? image) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.put(Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },

        // user can update name and image
        // TODO: user can update state location and other password also
        body: image == null
            ? {
                'name': name,
              }
            : {
                'name': name,
                'image': image,
              });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = someThingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// get state
Future<ApiResponse> getState() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(stateURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

      // manual typed
      // 'Keep-Alive': 'true',
      // 'Access-Control-Allow-Headers':
      // 'X-Requested-With, Content-Type, X-Token-Auth, Authorization',
    });

    print('state status code ${response.statusCode}');
    // print(jsonDecode(response.body)['news'][0]['news_image']);
    // print(jsonDecode(response.body)['news'][0]['news_image'].runtimeType);

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['state']
            .map((s) => State.fromJson(s))
            .toList();

        // getting list of state so we need to map for each item to State model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// get district
Future<ApiResponse> getDistrict(int stateId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$districtURL/$stateId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

      // manual typed
      // 'Keep-Alive': 'true',
      // 'Access-Control-Allow-Headers':
      // 'X-Requested-With, Content-Type, X-Token-Auth, Authorization',
    });

    print('state status code ${response.statusCode}');
    // print(jsonDecode(response.body)['news'][0]['news_image']);
    // print(jsonDecode(response.body)['news'][0]['news_image'].runtimeType);

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['district']
            .map((d) => District.fromJson(d))
            .toList();

        // getting list of state so we need to map for each item to State model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// get city
Future<ApiResponse> getCity() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(stateURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

      // manual typed
      // 'Keep-Alive': 'true',
      // 'Access-Control-Allow-Headers':
      // 'X-Requested-With, Content-Type, X-Token-Auth, Authorization',
    });

    print('state status code ${response.statusCode}');
    // print(jsonDecode(response.body)['news'][0]['news_image']);
    // print(jsonDecode(response.body)['news'][0]['news_image'].runtimeType);

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['state']
            .map((s) => State.fromJson(s))
            .toList();

        // getting list of state so we need to map for each item to State model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// get token function
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id function
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// logout function
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// get base64 encode image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
