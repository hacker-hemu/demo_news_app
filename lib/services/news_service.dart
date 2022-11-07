import 'dart:convert';

import 'package:demo_news_app/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/news.dart';

// get all news
Future<ApiResponse> getNews() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(newsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

      // manual typed
      // 'Keep-Alive': 'true',
      // 'Access-Control-Allow-Headers':
      // 'X-Requested-With, Content-Type, X-Token-Auth, Authorization',
    });

    print(response.statusCode);
    // print(jsonDecode(response.body)['news'][0]['news_image']);
    // print(jsonDecode(response.body)['news'][0]['news_image'].runtimeType);

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['news']
            .map((p) => News.fromJson(p))
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

// create news
Future<ApiResponse> createNews(
    String title, String news_desc, dynamic categoryId, String image) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(newsURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },

      // if image is not null so send image and other field also
      body: image != null
          ? {
              'title': title,
              'news_desc': news_desc,
              // 'content': content,
              'category_id': categoryId,
              'image': image,
            }
          :
          //if image is null so just send these fields
          {
              'title': title,
              'news_desc': news_desc,
              // 'content': content,
              'category_id': categoryId,
            },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
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

// edit news
Future<ApiResponse> editNews(int newsId, String title, String news_desc) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$newsURL/$newsId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'title': title,
        'news_desc': news_desc,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

// delete news
Future<ApiResponse> deleteNews(int newsId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$newsURL/$newsId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

// news like and unlike function
Future<ApiResponse> likeUnLikeNews(int newsId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$newsURL/$newsId/likes'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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

// login user news
Future<ApiResponse> getUserNews() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userNewsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

      // manual typed
      // 'Keep-Alive': 'true',
      // 'Access-Control-Allow-Headers':
      // 'X-Requested-With, Content-Type, X-Token-Auth, Authorization',
    });

    print(response.statusCode);
    // print(jsonDecode(response.body)['news'][0]['news_image']);
    // print(jsonDecode(response.body)['news'][0]['news_image'].runtimeType);

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.data = jsonDecode(response.body)['news']
            .map((n) => News.fromJson(n))
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
