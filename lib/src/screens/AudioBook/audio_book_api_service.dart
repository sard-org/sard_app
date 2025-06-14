import 'package:dio/dio.dart';
import '../Books/data/dio_client.dart';
import 'audio_book_model.dart';

class AudioBookApiService {
  final Dio _dio = DioClient.dio;

  Future<AudioBookResponse> getAudioBook(String bookId) async {
    try {
      final response = await _dio.get('books/$bookId');

      if (response.statusCode == 200) {
        return AudioBookResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load audio book: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Audio book not found');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout: Please check your internet connection');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout');
      } else {
        throw Exception('Failed to load audio book: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
