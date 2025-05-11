import 'package:dio/dio.dart';
import 'dart:developer';

class DioHelper {
  static Dio dio = Dio();
  static String? _token;

  static void init() {
    dio.options.baseUrl = 'https://api.mohamed-ramadan.me/api/';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    // إضافة معترض للطلبات لطباعة معلومات التصحيح
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
          return handler.next(e);
        }
    ));
  }

  static void setToken(String token) {
    _token = token;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static void removeToken() {
    _token = null;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Future<Response> getData({
    required String url,
  }) async {
    try {
      // طباعة تفاصيل الطلب
      log('Making GET request to: ${dio.options.baseUrl}$url');
      log('Headers: ${dio.options.headers}');

      final response = await dio.get(url);

      // طباعة الاستجابة
      log('Response received: ${response.statusCode}');
      log('Response data: ${response.data}');

      return response;
    } catch (e) {
      log('Error in getData: $e');
      rethrow;
    }
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    try {
      // طباعة تفاصيل الطلب
      log('Making POST request to: ${dio.options.baseUrl}$url');
      log('Headers: ${dio.options.headers}');
      log('Data: $data');

      final response = await dio.post(url, data: data);

      // طباعة الاستجابة
      log('Response received: ${response.statusCode}');
      log('Response data: ${response.data}');

      return response;
    } catch (e) {
      log('Error in postData: $e');
      rethrow;
    }
  }
}