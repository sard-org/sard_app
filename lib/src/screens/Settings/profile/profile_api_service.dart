import 'package:dio/dio.dart';
import 'package:sard/src/models/user_model.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

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

  // Update user profile data with optional image
  Future<UserModel> updateUserProfile(
    Map<String, dynamic> userData, {
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      FormData formData = FormData();
      
      // Add text fields
      userData.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });
      
      // Add image file if provided
      if (imageFile != null && !kIsWeb) {
        String fileName = imageFile.path.split('/').last;
        formData.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(imageFile.path, filename: fileName),
        ));
      } else if (imageBytes != null && kIsWeb) {
        // For web, use bytes
        String fileName = imageName ?? 'profile_image.jpg';
        formData.files.add(MapEntry(
          'photo',
          MultipartFile.fromBytes(imageBytes, filename: fileName),
        ));
      }

      final response = await _dio.patch(
        'users/me',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
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