import 'package:dio/dio.dart';
import '../../Books/data/dio_client.dart';
import 'search_books_model.dart';

class SearchBooksApiService {
  final Dio _dio = DioClient.dio;

  Future<List<SearchBook>> searchBooks(String query) async {
    try {
      // URL encode the search query
      final encodedQuery = Uri.encodeComponent(query.trim());

      final response = await _dio.get('books?search=$encodedQuery');

      if (response.statusCode == 200) {
        final searchBooksResponse = SearchBooksResponse.fromJson(response.data);
        return searchBooksResponse.books;
      } else {
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (e.response?.statusCode == 404) {
        throw Exception('No books found for your search');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout: Please check your internet connection');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout');
      } else {
        throw Exception('Failed to search books: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
