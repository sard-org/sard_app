import 'package:dio/dio.dart';
import '../../../Books/data/dio_client.dart';
import 'recommendations_model.dart';

class RecommendationsApiService {
  final Dio _dio = DioClient.dio;
  Future<List<RecommendedBook>> getRecommendations({int? limit}) async {
    try {
      final response = await _dio.get('books/recommendations');

      if (response.statusCode == 200) {
        final recommendationsResponse =
            RecommendationsResponse.fromJson(response.data);

        // Return limited books or all books if no limit specified
        if (limit != null) {
          return recommendationsResponse.books.take(limit).toList();
        } else {
          return recommendationsResponse.books;
        }
      } else {
        throw Exception(
            'Failed to load recommendations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Recommendations not found');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout: Please check your internet connection');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout');
      } else {
        throw Exception('Failed to load recommendations: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
