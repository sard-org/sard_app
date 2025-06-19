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

  // New method to get audio book content by order ID
  Future<AudioBookContentResponse> getAudioBookByOrderId(String orderId) async {
    try {
      print('Fetching audio book content for order: $orderId');
      final response = await _dio.get(
        '$_baseUrl/orders/$orderId/book',
        options: Options(
          sendTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AudioBookContentResponse.fromJson(response.data);
      } else {
        throw Exception('فشل في تحميل محتوى الكتاب الصوتي: خطأ في الخادم (${response.statusCode})');
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.statusCode == 401) {
        errorMessage = 'غير مصرح: يرجى تسجيل الدخول مرة أخرى';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'الطلب غير موجود أو لا تملك صلاحية للوصول إليه';
      } else if (e.response?.statusCode == 400) {
        errorMessage = 'طلب غير صحيح: يرجى المحاولة مرة أخرى';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'خطأ في الخادم: يرجى المحاولة لاحقاً';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'انتهت مهلة الاتصال: يرجى التحقق من اتصال الإنترنت';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة الاستجابة من الخادم';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'انتهت مهلة إرسال البيانات';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'خطأ في الاتصال: يرجى التحقق من اتصال الإنترنت';
      } else {
        errorMessage = 'فشل في تحميل محتوى الكتاب الصوتي: ${e.message ?? 'خطأ غير معروف'}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (e is Exception && e.toString().startsWith('Exception: ')) rethrow;
      throw Exception('خطأ غير متوقع: $e');
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
