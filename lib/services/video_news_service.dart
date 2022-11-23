import 'dart:convert';

import 'package:demo_news_app/models/videoNews.dart';
import 'package:demo_news_app/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/api_response.dart';

// get all news
Future<ApiResponse> getVideoNews() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(videoNewsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

      // manual typed
      // 'Keep-Alive': 'true',
      // 'Access-Control-Allow-Headers':
      // 'X-Requested-With, Content-Type, X-Token-Auth, Authorization',
    });

    print('status code for video News${response.statusCode}');
    print(jsonDecode(response.body)['videos'][0]['video_link']);
    // print(jsonDecode(response.body)['news'][0]['news_image'].runtimeType);

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['videos']
            .map((v) => VideoNews.fromJson(v))
            .toList();

        // getting list of news so we need to map for each item to News model
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
