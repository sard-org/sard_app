import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_summary_response.dart';

class BookService {
  static final BookService _instance = BookService._internal();
  late Dio _dio;

  factory BookService() {
    return _instance;
  }

  BookService._internal() {
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
  Future<String> getBookSummary(String bookId) async {
    try {
      final response = await _dio.get('/books/$bookId/summary');

      if (response.statusCode == 200 && response.data != null) {
        final summaryResponse = BookSummaryResponse.fromJson(response.data);
        return summaryResponse.summary.isNotEmpty
            ? summaryResponse.summary
            : 'لا يوجد ملخص متاح';
      } else {
        throw Exception('Failed to get book summary');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('الكتاب غير موجود');
      } else if (e.response?.statusCode == 500) {
        throw Exception('خطأ في الخادم');
      } else {
        throw Exception('فشل في الحصول على الملخص');
      }
    } catch (e) {
      throw Exception('فشل في الحصول على الملخص: $e');
    }
  }

  Future<Map<String, dynamic>> addBookReview(
      String bookId, int numberOfStars) async {
    try {
      final response = await _dio.post(
        '/books/$bookId/review',
        data: {'numberOfStars': numberOfStars},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('فشل في إضافة التقييم');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // User has already reviewed this book
        if (e.response?.data != null && e.response!.data['message'] != null) {
          throw Exception(e.response!.data['message']);
        } else {
          throw Exception('لقد قمت بتقييم هذا الكتاب مسبقاً');
        }
      } else if (e.response?.statusCode == 404) {
        throw Exception('الكتاب غير موجود');
      } else if (e.response?.statusCode == 401) {
        throw Exception('يجب تسجيل الدخول أولاً');
      } else {
        throw Exception('فشل في إضافة التقييم');
      }
    } catch (e) {
      throw Exception('فشل في إضافة التقييم: $e');
    }
  }
}
