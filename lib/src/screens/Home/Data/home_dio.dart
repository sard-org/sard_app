import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDio {
  static final Dio dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.baseUrl = 'https://api.mohamed-ramadan.me/api/';
          return handler.next(options);
        },
      ),
    );
}
