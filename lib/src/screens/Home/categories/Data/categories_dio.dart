import 'package:dio/dio.dart';

class CategoriesDio {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://api.mohamed-ramadan.me/api/'),
  );

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get('/categories/');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
