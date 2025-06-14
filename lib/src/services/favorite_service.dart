import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  late Dio _dio;

  factory FavoriteService() {
    return _instance;
  }

  FavoriteService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.mohamed-ramadan.me/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(
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

  Future<void> toggleFavorite(String bookId, bool currentlyFavorite) async {
    try {
      if (currentlyFavorite) {
        // Remove from favorites
        await _dio.delete(
          '/favorite',
          data: {"bookId": bookId},
        );
      } else {
        // Add to favorites
        await _dio.post(
          '/favorite',
          data: {"bookId": bookId},
        );
      }
    } catch (e) {
      throw Exception('Failed to update favorite status: $e');
    }
  }

  Future<bool> addToFavorite(String bookId) async {
    try {
      await _dio.post(
        '/favorite',
        data: {"bookId": bookId},
      );
      return true;
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<bool> removeFromFavorite(String bookId) async {
    try {
      await _dio.delete(
        '/favorite',
        data: {"bookId": bookId},
      );
      return true;
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  Future<List<dynamic>> getFavorites() async {
    try {
      final response = await _dio.get('/favorite');
      final List<dynamic> favorites = response.data['favorites'];
      final List<dynamic> books = favorites.map((e) => e['book']).toList();
      return books;
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }
}
