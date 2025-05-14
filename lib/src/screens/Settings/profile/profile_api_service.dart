import 'package:dio/dio.dart';
import 'package:sard/src/models/user_model.dart';

class ProfileApiService {
  final Dio _dio;

  ProfileApiService(this._dio);

  // Initialize the service with base URL and token
  static ProfileApiService init(String token) {
    final dio = Dio();
    dio.options.baseUrl = 'https://api.mohamed-ramadan.me/api/';
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    return ProfileApiService(dio);
  }

  // Get user profile data
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get('users/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      throw 'Failed to get user profile';
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Update user profile data
  Future<UserModel> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.patch(
        'users/me',
        data: userData,
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      throw 'Failed to update user profile';
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Handle errors from API calls
  void _handleError(dynamic error) {
    if (error is DioException) {
      print('DioError: ${error.message}');
      print('Response data: ${error.response?.data}');
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