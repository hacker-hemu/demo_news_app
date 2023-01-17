import 'dart:convert';

import 'package:demo_news_app/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/api_response.dart';
import '../../models/tv_models/live_tv_video.dart';

// get all news
Future<ApiResponse> getLiveTvVideo() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(liveTvVideoURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['liveTvVideo']
            .map((p) => LiveTvVideo.fromJson(p))
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
