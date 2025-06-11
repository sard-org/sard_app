import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categories_model.dart';

class CategoriesService {
  final Dio dio;

  CategoriesService(this.dio) {
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      print('Error initializing CategoriesService: $e');
    }
  }

  Future<CategoryResponse> getCategories() async {
    try {
      await _init(); // Refresh token before request
      final response = await dio.get('categories');
      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load categories: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      }
      throw Exception('Failed to load categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // Future<List<dynamic>> getCategoryBooks(String category_id) async {
  //   try {
  //     await _init(); // Refresh token before request

  //     final response = await dio.get(
  //       'books',
  //       queryParameters: {
  //         'category_id': category_id,
  //       },
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to load books: Invalid response');
  //     }

  //     if (response.data == null) {
  //       return [];
  //     }

  //     // Print response for debugging
  //     print('API Response for category $category_id: ${response.data}');

  //     if (response.data is Map<String, dynamic>) {
  //       if (response.data['books'] != null) {
  //         return response.data['books'] as List<dynamic>;
  //       } else if (response.data['data'] != null) {
  //         return response.data['data'] as List<dynamic>;
  //       }
  //     }

  //     if (response.data is List<dynamic>) {
  //       return response.data;
  //     }

  //     return [];
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 401) {
  //       throw Exception('Unauthorized: Please login again');
  //     }
  //     throw Exception('Failed to load books: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Failed to load books: $e');
  //   }
  // }

  Future<List<dynamic>> getCategoryBooks(String categoryId) async {
    try {
      await _init(); // Refresh token before request

      final response = await dio.get(
        'books',
        queryParameters: {
          'category_id': categoryId,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load books: Invalid response');
      }

      if (response.data == null) {
        return [];
      }

      print('API Response for category $categoryId: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        if (response.data['books'] != null) {
          return response.data['books'] as List<dynamic>;
        } else if (response.data['data'] != null) {
          return response.data['data'] as List<dynamic>;
        }
      }

      if (response.data is List<dynamic>) {
        return response.data;
      }

      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      }
      throw Exception('Failed to load books: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }
}
