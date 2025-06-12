import 'package:dio/dio.dart';
import '../../../Books/data/dio_client.dart';
import 'exchange_books_model.dart';

class ExchangeBooksApiService {
  final Dio _dio = DioClient.dio;
  Future<List<ExchangeBook>> getExchangeBooks({int? limit}) async {
    try {
      final response = await _dio.get('books/points');

      if (response.statusCode == 200) {
        final exchangeBooksResponse =
            ExchangeBooksResponse.fromJson(response.data);

        // Return limited books or all books if no limit specified
        if (limit != null) {
          return exchangeBooksResponse.books.take(limit).toList();
        } else {
          return exchangeBooksResponse.books;
        }
      } else {
        throw Exception(
            'Failed to load exchange books: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Exchange books not found');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout: Please check your internet connection');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout');
      } else {
        throw Exception('Failed to load exchange books: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
