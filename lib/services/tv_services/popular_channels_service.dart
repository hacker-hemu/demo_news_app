import 'dart:convert';

import 'package:demo_news_app/models/tv_models/popular_channels.dart';
import 'package:demo_news_app/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/api_response.dart';

// get all news
Future<ApiResponse> getPopularChannels() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(popularChannelsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['popularChannels']
            .map((p) => PopularChannels.fromJson(p))
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
