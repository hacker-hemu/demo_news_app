import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:demo_news_app/services/user_service.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/news_category.dart';

// get news category detail
Future<ApiResponse> getNewsCategoryDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(categoryURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['category']
            .map((p) => Category.fromJson(p))
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
