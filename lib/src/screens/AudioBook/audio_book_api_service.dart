import 'dart:convert';
import 'package:dio/dio.dart';
import '../Books/data/dio_client.dart';
import 'audio_book_model.dart';

class AudioBookApiService {
  final Dio _dio = DioClient.dio;
  final String _baseUrl = 'https://api.mohamed-ramadan.me/api';

  Future<AudioBookResponse> getAudioBook(String bookId) async {
    try {
      final response = await _dio.get('$_baseUrl/books/$bookId');
      return AudioBookResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<OrderResponse> orderBook(String bookId) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/orders',
        data: {'bookId': bookId},
      );
      return OrderResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        if (error.response?.data['message'] != null) {
          return error.response?.data['message'];
        }
      }
      return error.message ?? 'حدث خطأ ما';
    }
    return error.toString();
  }
}
