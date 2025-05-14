import 'package:dio/dio.dart';

class PasswordResetApiService {
  final Dio _dio;

  PasswordResetApiService(this._dio);

  // Initialize the service with base URL
  static PasswordResetApiService init() {
    final dio = Dio();
    dio.options.baseUrl = 'https://api.mohamed-ramadan.me/api/';
    return PasswordResetApiService(dio);
  }

  // Step 1: Send email to get the OTP code
  Future<bool> sendResetEmail(String email) async {
    try {
      final response = await _dio.post(
        'auth/forget-password',
        data: {'email': email},
      );

      // Consider any 2xx status code as success
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          return response.data['success'] == true || response.data['status'] == 'success';
        }
        return true;
      }
      return false;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  // Step 2: Validate OTP code
  Future<bool> validateOtp(String email, String code) async {
    try {
      final response = await _dio.post(
        'auth/validate-password-otp',
        data: {
          'email': email,
          'code': code,
        },
      );

      // Consider any 2xx status code as success
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          return response.data['success'] == true || response.data['status'] == 'success';
        }
        return true;
      }
      return false;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  // Step 3: Reset password with new password
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final response = await _dio.patch(
        'auth/reset-password',
        data: {
          'email': email,
          'new_password': newPassword,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  // Handle errors from API calls
  void _handleError(dynamic error) {
    if (error is DioException) {
      print('DioError: ${error.message}');
      print('Response data: ${error.response?.data}');
      // If there's a specific error message in the response, we can throw it
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response?.data as Map<String, dynamic>;
        if (data.containsKey('message')) {
          throw data['message'];
        }
      }
    } else {
      print('Unexpected error: $error');
    }
  }
}