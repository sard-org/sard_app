import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioFav {
  final Dio dio;

  DioFav(this.dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<List<dynamic>> getFavorites(String token) async {
    try {
      final response = await dio.get(
        '/favorite',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> favorites = response.data['favorites'];
      final List<dynamic> books = favorites.map((e) => e['book']).toList();
      return books;
    } catch (e) {
      throw Exception('فشل في جلب المفضلات: $e');
    }
  }

  Future<void> addToFavorite(String token, String bookId) async {
    await dio.post(
      '/favorite',
      data: {"bookId": bookId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<void> removeFromFavorite(String token, String bookId) async {
    await dio.delete(
      '/favorite',
      data: {"bookId": bookId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
