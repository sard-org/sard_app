import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio = Dio();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio.options.baseUrl = 'https://api.mohamed-ramadan.me';
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // إضافة interceptors للتعامل مع الاستجابات والأخطاء
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        return handler.next(e);
      },
    ));
  }

  // الحصول على نسخة dio
  Dio get dio => _dio;

  // طلب تسجيل حساب جديد
  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // طلب التحقق من البريد الإلكتروني (إرسال OTP)
  Future<Response> validateEmail({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/validate-email',
        data: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // التحقق من رمز OTP المرسل إلى البريد الإلكتروني
  Future<Response> validateEmailOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/validate-email-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}