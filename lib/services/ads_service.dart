import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:demo_news_app/models/ads.dart';
import 'package:demo_news_app/services/user_service.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';

// get advertisement detail
Future<ApiResponse> getAdsDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(adsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['ads']
            .map((p) => Ads.fromJson(p))
            .toList();
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
