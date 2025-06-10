import 'package:dio/dio.dart';
import 'categories_model.dart';

class CategoriesService {
  final Dio dio;

  CategoriesService(this.dio);

  Future<CategoryResponse> getCategories() async {
    try {
      final response = await dio.get('categories');
      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<dynamic>> getCategoryBooks(String categoryId) async {
    try {
      final response = await dio.get('books', queryParameters: {
        'category_id': categoryId,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }
}
